import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreServico {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _listas = FirebaseFirestore.instance.collection('Listas');

  Future<List> obterMinhasListas() async {
    List minhasListas = [];
    final dados = await _firestore.collection('Listas').get();
    for (var nomeLista in dados.docs) {
      minhasListas.add(nomeLista.get('nome'));
    }
    return minhasListas;
  }

  Future<List> obterItemsDaLista(String nomeDaLista) async {
    List listaDeItems = [];

    final dados = await _listas.where('nome', isEqualTo: nomeDaLista).get();
    for (var colecaoID in dados.docs) {
      final itemLista =
          await _listas.doc(colecaoID.id).collection('items').get();
      for (var item in itemLista.docs) {
        listaDeItems.add(item.get('itemLista'));
      }
    }
    return listaDeItems;
  }

  Future adicionarTarefa(String nomeDaLista, String itemLista) async {
    final dados = await _listas.where('nome', isEqualTo: nomeDaLista).get();
    for (var colecaoID in dados.docs) {
      _listas.doc(colecaoID.id).collection('items').add(
          {'itemLista': itemLista}).then((value) => print('Item adicionado'));
    }
  }

  Future novaLista(String nomeDaLista) async {
    await _listas.add({'nome': nomeDaLista});
  }

  Future removerLista(String nomeDaLista) async {
    final documentos =
        await _listas.where('nome', isEqualTo: nomeDaLista).get();
    for (var dados in documentos.docs) {
      _listas.doc(dados.id).delete().then((value) => print('Lista apagada'));
    }
  }

  Future removerItemDaLista(String nomeDaLista, String nomeItem) async {
    final documentos =
        await _listas.where('nome', isEqualTo: nomeDaLista).get();
    for (var docID in documentos.docs) {
      final items = await _listas
          .doc(docID.id)
          .collection('items')
          .where('itemLista', isEqualTo: nomeItem)
          .get();
      for (var itemID in items.docs) {
        _listas.doc(docID.id).collection('items').doc(itemID.id).delete();
      }
    }
  }
}
