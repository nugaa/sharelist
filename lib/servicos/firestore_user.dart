import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  Future adicionarUser({String nome, String email, String fotoUrl}) async {
    try {
      _users.doc(email).set({
        'nome': nome,
        'fotoUrl': fotoUrl,
      }).whenComplete(() => print('Utilizador adicionado'));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
