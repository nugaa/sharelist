import 'dart:async';

import 'package:afazeres/servicos/firestore_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum opcao {
  Google,
  Facebook,
}

class Auth_Bloc {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;
  FirestoreUser _firestoreUser = FirestoreUser();

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

  void logout() async {
    googleSignIn.signOut();
    googleSignIn.disconnect();
    _firebaseAuth.signOut();
  }
}
