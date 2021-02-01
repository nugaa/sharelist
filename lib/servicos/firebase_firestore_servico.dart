import 'package:afazeres/models/postit_info.dart';
import 'package:afazeres/models/tarefas_data.dart';
import 'package:afazeres/widgets/list_checkbox_tile.dart';
import 'package:afazeres/widgets/waitNoticeWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FirebaseFirestoreServico {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _listas = FirebaseFirestore.instance.collection('Listas');

  Future<List> obterMinhasListas() async {
    List minhasListas = [];
    final dados = await _listas.get();
    for (var nomeLista in dados.docs) {
      minhasListas.add({nomeLista.get('nome'), nomeLista.get('cor')});
    }
    return minhasListas;
  }

  Future<String> obterIdLista(String nomeDaLista) async {
    String idLista;
    final dados = await _listas.where('nome', isEqualTo: nomeDaLista).get();
    for (var colecaoID in dados.docs) {
      idLista = colecaoID.id;
    }
    return idLista;
  }

  Future<String> obterIdItem(String idDoc, String nomeItem) async {
    String idItem;
    final dados = await _listas
        .doc(idDoc)
        .collection('items')
        .where('itemLista', isEqualTo: nomeItem)
        .get();
    for (var colecaoID in dados.docs) {
      idItem = colecaoID.id;
    }
    return idItem;
  }

  Future obterNomeLista(String idDoc) async {
    final dados = await _listas.doc(idDoc).get();
    String nomeLista = dados.data()['nome'];
    if (nomeLista != null && nomeLista != '') {
      return nomeLista;
    }
  }

  StreamBuilder streamNomeLista() {
    return StreamBuilder<QuerySnapshot>(
        stream: _listas.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return waitNoticeWidget(context, 'A carregar listas...');
          }
          final nomeDaLista = snapshot.data.docs;
          List<Widget> widgetListaNomes = [];
          List<StaggeredTile> staggers = [];
          for (var nomeItem in nomeDaLista) {
            if (nomeItem['cor'].contains('0xff')) {
              var str = nomeItem['cor'];
              var start = ": Color(";
              var end = ")";
              String hexCor;
              final startIndex = str.indexOf(start);
              final endIndex = str.indexOf(end, startIndex + start.length);
              hexCor = str.substring(startIndex + start.length, endIndex);
              var nomeWidget =
                  PostItInfo().tilesAdd(hexToColor(hexCor), nomeItem['nome']);
              staggers.add(StaggeredTile.count(1, 1));
              widgetListaNomes.add(nomeWidget);
            }
          }
          return StaggeredGridView.count(
            crossAxisCount: 2,
            staggeredTiles: staggers,
            children: widgetListaNomes,
          );
        });
  }

  Color hexToColor(String code) {
    return Color(int.parse(code));
  }

  StreamBuilder streamBuilderTarefas(String idDoc) {
    return StreamBuilder<QuerySnapshot>(
      stream: _listas.doc(idDoc).collection('items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return waitNoticeWidget(context, 'A carregar items...');
        }
        final itemsDaLista = snapshot.data.docs;
        List<Text> itemsWidgets = [];
        List<String> itemsLista = [];
        List<bool> checkados = [];
        for (var item in itemsDaLista) {
          final itemTexto = item['itemLista'];
          final itemWidget = Text(
            itemTexto,
            style: TextStyle(
              fontSize: 20.0,
            ),
          );
          itemsLista.add(itemTexto);
          checkados.add(item['isChecked']);
          itemsWidgets.add(itemWidget);
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: itemsWidgets.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(itemsLista[index]),
                background: Container(
                  color: Colors.redAccent,
                ),
                onDismissed: (direcao) {
                  removerItemDaLista(idDoc, itemsLista[index]);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ListCheckboxTile(
                      nomeTarefa: itemsLista[index],
                      isChecked: checkados[index],
                      toggleIt: (bool checkboxState) {
                        Provider.of<TarefasData>(context, listen: false)
                            .checkboxToggle(
                                idDoc, itemsLista[index], checkboxState);
                      },
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Future alterarIsChecked(String idDoc, String nomeItem, bool isChecked) async {
    bool trocar;
    trocar = isChecked;
    String nomeId = await obterIdItem(idDoc, nomeItem);
    _listas
        .doc(idDoc)
        .collection('items')
        .doc(nomeId)
        .update({'isChecked': trocar});
  }

  Future adicionarTarefa(String idDaLista, String itemLista) async {
    bool isChecked = false;
    print(idDaLista);
    final documento = await _listas.where('nome', isEqualTo: idDaLista).get();
    for (var doc in documento.docs) {
      _listas
          .doc(doc.id)
          .collection('items')
          .add({'itemLista': itemLista, 'isChecked': isChecked}).then(
              (value) => print('Item adicionado'));
    }
  }

  Future novaLista(String nomeDaLista, int id, String corDaLista) async {
    await _listas.doc(id.toString()).set({
      'nome': nomeDaLista,
      'cor': corDaLista,
    });
  }

  Future removerLista(String nomeDaLista) async {
    _listas.doc(nomeDaLista).collection('items').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    _listas.doc(nomeDaLista).delete().then((value) => print('Lista apagada'));
  }

  Future removerItemDaLista(String idDoc, String nomeItem) async {
    final documentos = await _listas
        .doc(idDoc)
        .collection('items')
        .where('itemLista', isEqualTo: nomeItem)
        .get();
    for (var docID in documentos.docs) {
      _listas.doc(idDoc).collection('items').doc(docID.id).delete();
    }
  }
}
