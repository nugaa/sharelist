import 'package:afazeres/models/postit_info.dart';
import 'package:afazeres/models/tarefas_data.dart';
import 'package:afazeres/widgets/list_checkbox_tile.dart';
import 'package:afazeres/widgets/waitNoticeWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FirestoreListas {
  CollectionReference _users = FirebaseFirestore.instance.collection('Users');
  CollectionReference _listaPartilhada =
      FirebaseFirestore.instance.collection('ListaPartilhada');

  Future<List> obterMinhasListas(String email) async {
    List minhasListas = [];
    final dados = await _users.doc(email).collection('listas').get();
    for (var nomeLista in dados.docs) {
      minhasListas.add({nomeLista.get('nome'), nomeLista.get('cor')});
    }
    return minhasListas;
  }

  Future<String> obterIdLista(
      String email, String nomeDaLista, bool isShared) async {
    String idLista;
    if (!isShared) {
      final dados = await _users
          .doc(email)
          .collection('listas')
          .where('nome', isEqualTo: nomeDaLista)
          .get();
      for (var colecaoID in dados.docs) {
        idLista = colecaoID.id;
      }
      return idLista;
    } else {
      final dados = await _listaPartilhada
          .where('nome', isEqualTo: nomeDaLista)
          .where('partilha', arrayContains: email)
          .get();
      for (var id in dados.docs) {
        idLista = id.id;
      }
      return idLista;
    }
  }

  Future<String> obterIdItem(
      String email, String idDoc, String nomeItem, bool isShared) async {
    String idItem;
    final dados = isShared
        ? await _users
            .doc(email)
            .collection('listas')
            .doc(idDoc)
            .collection('items')
            .where('itemLista', isEqualTo: nomeItem)
            .get()
        : await _listaPartilhada
            .doc(idDoc)
            .collection('items')
            .where('itemLista', isEqualTo: nomeItem)
            .get();
    for (var colecaoID in dados.docs) {
      idItem = colecaoID.id;
    }
    return idItem;
  }

  Future obterNomeLista(String email, String idDoc) async {
    final dados = await _users.doc(email).collection('listas').doc(idDoc).get();
    String nomeLista = dados.data()['nome'];
    if (nomeLista != null && nomeLista != '') {
      return nomeLista;
    }
  }

  StreamBuilder streamNomeLista(String email, bool isShared) {
    return !isShared
        ? StreamBuilder<QuerySnapshot>(
            stream: _users.doc(email).collection('listas').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return waitInternetWidget(context, 'A carregar listas...');
              } else if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Ainda não adicionou nenhuma lista',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
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
                  var nomeWidget = PostItInfo().tilesAdd(
                    cor: hexToColor(hexCor),
                    nome: nomeItem['nome'],
                    email: email,
                    isShared: false,
                  );
                  staggers.add(StaggeredTile.count(2, 0.3));
                  widgetListaNomes.add(nomeWidget);
                }
              }
              return StaggeredGridView.count(
                crossAxisCount: 2,
                staggeredTiles: staggers,
                children: widgetListaNomes,
              );
            })
        : StreamBuilder(
            stream: _listaPartilhada
                .where('partilha', arrayContains: email)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return waitInternetWidget(context, 'A carregar listas...');
              } else if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Não está em nenhuma lista partilhada',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              final lista = snapshot.data.docs;
              List<Widget> listaWidgets = [];
              List<StaggeredTile> staggers = [];
              for (var i in lista) {
                if (i['cor'].contains('0xff')) {
                  var str = i['cor'];
                  var start = ": Color(";
                  var end = ")";
                  String hexCor;
                  final startIndex = str.indexOf(start);
                  final endIndex = str.indexOf(end, startIndex + start.length);
                  hexCor = str.substring(startIndex + start.length, endIndex);
                  var nomeWidget = PostItInfo().tilesAdd(
                      cor: hexToColor(hexCor),
                      nome: i['nome'],
                      email: email,
                      isShared: true);
                  staggers.add(StaggeredTile.count(2, 0.3));
                  listaWidgets.add(nomeWidget);
                }
              }
              return StaggeredGridView.count(
                crossAxisCount: 2,
                staggeredTiles: staggers,
                children: listaWidgets,
              );
            },
          );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code));
  }

  StreamBuilder streamBuilderTarefas(
      String email, String idDoc, bool isShared) {
    return !isShared
        ? StreamBuilder<QuerySnapshot>(
            stream: _users
                .doc(email)
                .collection('listas')
                .doc(idDoc)
                .collection('items')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: waitInternetWidget(context, 'A carregar items...'));
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
              return Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemsWidgets.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(itemsLista[index]),
                        background: Container(
                          color: Colors.redAccent,
                        ),
                        onDismissed: (direcao) {
                          removerItemDaLista(
                              email, idDoc, itemsLista[index], isShared);
                        },
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ListCheckboxTile(
                              nomeTarefa: itemsLista[index],
                              isChecked: checkados[index],
                              toggleIt: (bool checkboxState) {
                                Provider.of<TarefasData>(context, listen: false)
                                    .checkboxToggle(
                                        email,
                                        idDoc,
                                        itemsLista[index],
                                        checkboxState,
                                        isShared);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              );
            },
          )
        : StreamBuilder<QuerySnapshot>(
            stream: _listaPartilhada.doc(idDoc).collection('items').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: waitInternetWidget(context, 'A carregar items...'));
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
              return Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemsWidgets.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(itemsLista[index]),
                        background: Container(
                          color: Colors.redAccent,
                        ),
                        onDismissed: (direcao) {
                          removerItemDaLista(
                              email, idDoc, itemsLista[index], isShared);
                        },
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ListCheckboxTile(
                              nomeTarefa: itemsLista[index],
                              isChecked: checkados[index],
                              toggleIt: (bool checkboxState) {
                                Provider.of<TarefasData>(context, listen: false)
                                    .checkboxToggle(
                                        email,
                                        idDoc,
                                        itemsLista[index],
                                        checkboxState,
                                        isShared);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              );
            },
          );
  }

  Future alterarIsChecked(String email, String idDoc, String nomeItem,
      bool isChecked, bool isShared) async {
    bool trocar;
    trocar = isChecked;
    String nomeId = await obterIdItem(email, idDoc, nomeItem, !isShared);
    !isShared
        ? _users
            .doc(email)
            .collection('listas')
            .doc(idDoc)
            .collection('items')
            .doc(nomeId)
            .update({'isChecked': trocar})
        : _listaPartilhada
            .doc(idDoc)
            .collection('items')
            .doc(nomeId)
            .update({'isChecked': trocar});
  }

  Future adicionarTarefa(
      String email, String idDaLista, String itemLista, bool isShared) async {
    bool isChecked = false;
    if (!isShared) {
      final documento = await _users
          .doc(email)
          .collection('listas')
          .where('nome', isEqualTo: idDaLista)
          .get();
      if (itemLista.isNotEmpty) {
        for (var doc in documento.docs) {
          await _users
              .doc(email)
              .collection('listas')
              .doc(doc.id)
              .collection('items')
              .add({'itemLista': itemLista, 'isChecked': isChecked}).then(
                  (value) => print('Item adicionado'));
        }
      }
    } else {
      bool isChecked = false;
      final documento = await _listaPartilhada
          .where('partilha', arrayContains: email)
          .where('nome', isEqualTo: idDaLista)
          .get();
      print(documento.docs);
      if (itemLista.isNotEmpty) {
        for (var doc in documento.docs) {
          await _listaPartilhada
              .doc(doc.id)
              .collection('items')
              .add({'itemLista': itemLista, 'isChecked': isChecked}).then(
                  (value) => print('Item adicionado'));
        }
      }
    }
  }

  Future novaLista(
      String email, String nomeDaLista, int id, String corDaLista) async {
    await _users.doc(email).collection('listas').doc(id.toString()).set({
      'nome': nomeDaLista,
      'cor': corDaLista,
    });
  }

  Future removerLista(String email, String nomeDaLista, bool isShared) async {
    if (!isShared) {
      await _users
          .doc(email)
          .collection('listas')
          .doc(nomeDaLista)
          .collection('items')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          print(doc.reference);
          doc.reference.delete().then((value) => print('Items eliminados'));
        }
      });
      _users
          .doc(email)
          .collection('listas')
          .doc(nomeDaLista)
          .delete()
          .then((value) => print('Lista apagada'));
    } else {
      final documento =
          await _listaPartilhada.where('nome', isEqualTo: nomeDaLista).get();
      for (var doc in documento.docs) {
        if (email == doc.get('admin')) {
          doc.reference
              .delete()
              .then((value) => ('Items partilhados eliminados'));
          _listaPartilhada
              .doc(nomeDaLista)
              .delete()
              .then((value) => print('Lista apagada'));
        } else {
          return 'not admin';
        }
      }
    }
  }

  Future removerItemDaLista(
      String email, String idDoc, String nomeItem, bool isShared) async {
    if (!isShared) {
      final documentos = await _users
          .doc(email)
          .collection('listas')
          .doc(idDoc)
          .collection('items')
          .where('itemLista', isEqualTo: nomeItem)
          .get();
      for (var docID in documentos.docs) {
        await _users
            .doc(email)
            .collection('listas')
            .doc(idDoc)
            .collection('items')
            .doc(docID.id)
            .delete();
      }
    } else {
      final documentos = await _listaPartilhada
          .doc(idDoc)
          .collection('items')
          .where('itemLista', isEqualTo: nomeItem)
          .get();
      for (var docId in documentos.docs) {
        await _listaPartilhada
            .doc(idDoc)
            .collection('items')
            .doc(docId.id)
            .delete();
      }
    }
  }

  Future adicionarUserPartilha({
    String meuEmail,
    String emailOutro,
    String nomeLista,
    String cor,
  }) async {
    bool _emailExiste = false;
    final email = await _users.get();
    for (var e in email.docs) {
      if (e.id == emailOutro) {
        _emailExiste = true;
      }
    }

    if (_emailExiste == true && emailOutro != meuEmail) {
      /** Se já existir uma lista com o mesmo nomeLista e os 2 emails no partilha
       * não autorizar a partilha
       */
      final tabelaExiste = await _listaPartilhada.get();
      var i;
      for (i in tabelaExiste.docs) {}
      if (i.data().isNotEmpty) {
        final dados = await _listaPartilhada
            .where('admin', isEqualTo: meuEmail)
            .where('nome', isEqualTo: nomeLista)
            .get();
        if (dados.docs.isEmpty) {
          await _listaPartilhada.doc().set({
            'nome': nomeLista,
            'cor': '($cor)',
            'admin': meuEmail,
            'partilha': FieldValue.arrayUnion([meuEmail, emailOutro]),
          });
        } else {
          for (var dado in dados.docs) {
            if (dado.get('admin') == meuEmail &&
                dado.get('nome') == nomeLista) {
              await _listaPartilhada.doc(dado.id).update({
                'partilha': FieldValue.arrayUnion([emailOutro]),
              });
            }
          }
        }
      } else {
        await _listaPartilhada.doc().set({
          'nome': nomeLista,
          'cor': cor,
          'admin': meuEmail,
          'partilha': FieldValue.arrayUnion([meuEmail, emailOutro]),
        });
      }

      await partilharItems(email: meuEmail, nomeLista: nomeLista);
      return true;
    } else {
      return false;
    }
  }

  Future partilharItems({String email, String nomeLista}) async {
    List itemsPartilhar = [];
    final documentos = await _users
        .doc(email)
        .collection('listas')
        .where('nome', isEqualTo: nomeLista)
        .get();

    for (var doc in documentos.docs) {
      final lista = await _users
          .doc(email)
          .collection('listas')
          .doc(doc.id)
          .collection('items')
          .get();
      for (var item in lista.docs) {
        itemsPartilhar.add(item.data());
      }
    }
    final lista = await _listaPartilhada
        .where('admin', isEqualTo: email)
        .where('nome', isEqualTo: nomeLista)
        .get();
    if (lista.docs != null) {
      if (itemsPartilhar.isNotEmpty) {
        for (var idLista in lista.docs) {
          itemsPartilhar.forEach((element) {
            _listaPartilhada.doc(idLista.id).collection('items').add(element);
          });
        }
      }
    }
  }

  Future<bool> permitirPartilhar(
      String email, String outroEmail, String nomeLista, bool partilhar) async {
    bool permitirPartilha = false;
    String listaNomeDados;
    List listaEmails = [];
    final doc =
        await _listaPartilhada.where('nome', isEqualTo: nomeLista).get();

    if (doc.docs.isNotEmpty) {
      for (var i in doc.docs) {
        listaEmails = (i.data()['partilha']);
        listaNomeDados = i.data()['nome'];
      }
      if (listaEmails.contains(email) &&
          listaEmails.contains(outroEmail) &&
          listaNomeDados == nomeLista) {
        print('Não partilhar');
        return permitirPartilha;
      } else {
        if (partilhar == false) {
          return permitirPartilha;
        } else {
          permitirPartilha = true;
          print('Partilhar');
          return permitirPartilha;
        }
      }
    } else {
      permitirPartilha = true;
      return permitirPartilha;
    }
  }
}
