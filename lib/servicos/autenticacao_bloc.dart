import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:afazeres/servicos/firestore_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth_Bloc {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookSignIn = FacebookAuth.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  FirestoreUser _firestoreUser = FirestoreUser();
  var _fbData;

  Future<UserCredential> googleSignInn() async {
    UserCredential auth;
    try {
      final GoogleSignInAccount user = await googleSignIn.signIn();

      if (user != null) {
        final GoogleSignInAuthentication googleAuth = await user.authentication;
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        auth = await _firebaseAuth.signInWithCredential(credential);
        if (auth.additionalUserInfo.isNewUser == true) {
          _firestoreUser.adicionarUser(
            nome: auth.user.displayName,
            email: auth.user.email,
            fotoUrl: auth.user.photoURL,
          );
        }
      }
    } on FirebaseException catch (e) {
      print('Algo correu mal: $e');
    }
    return auth;
  }

  Future<UserCredential> facebookSignInn() async {
      try {
        final AccessToken accessToken = await FacebookAuth.instance.login();

        // Create a credential from the access token
        final FacebookAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name, '
                'first_name,last_name,email,picture.height(200)&'
                'access_token=${credential.accessToken}');
        _fbData = json.decode(graphResponse.body);
        // Once signed in, return the UserCredential
        final auth = await _firebaseAuth.signInWithCredential(credential);
        print(auth.user.providerData);
        if(auth.additionalUserInfo.isNewUser == true){
          _firestoreUser.adicionarUser(
            nome: auth.user.displayName,
            email: auth.user.email,
            fotoUrl: auth.user.photoURL,
          );
        }
      } on FacebookAuthException catch (e) {
        switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            print("You have a previous login operation in progress");
            break;
          case FacebookAuthErrorCode.CANCELLED:
            print("login cancelled");
            break;
          case FacebookAuthErrorCode.FAILED:
            print("login failed");
            break;
        }
      } on FirebaseException catch (e){
       print('FirebaseAuthException: $e');
      }finally {}
      return null;
  }

  Future obterDadosFacebook() async{
    await facebookSignInn();
    if(_fbData != null){
      return _fbData;
    }
  }
  void logout() async {
    googleSignIn.signOut();
    googleSignIn.disconnect();
    facebookSignIn.logOut();
    _firebaseAuth.signOut();
  }
}
