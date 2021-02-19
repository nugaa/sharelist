import 'package:afazeres/servicos/firestore_listas.dart';
import 'package:flutter/material.dart';

class TarefasData extends ChangeNotifier {
  Future<String> idDaLista(
      String email, String nomeDaLista, bool isShared) async {
    /** Obter id do documento **/
    String idDoc;
    idDoc = await FirestoreListas().obterIdLista(email, nomeDaLista, isShared);
    /**  ********************* **/
    return idDoc;
  }

  novaLista(String email, String nomeDaLista, String cor) async {
    List allLists = [];
    allLists = await FirestoreListas().obterMinhasListas(email);

    int cont = allLists.length + 1;

    FirestoreListas()
        .novaLista(email, nomeDaLista, cont, cor)
        .then((value) => print('Lista Adicionada'));
  }

  removerLista(String email, String nomeLista, bool isShared) async {
    var result =
        await FirestoreListas().removerLista(email, nomeLista, isShared);
    notifyListeners();
    return result;
  }

  void adicionarTarefa(
      String email, String novaTarefa, String idDaLista, bool isShared) {
    FirestoreListas().adicionarTarefa(email, idDaLista, novaTarefa, isShared);
  }

  Color hexToColor(String code) {
    return Color(int.parse(code));
  }

  checkboxToggle(String email, String idDoc, String nomeItem,
      bool checkboxState, bool isShared) async {
    FirestoreListas()
        .alterarIsChecked(email, idDoc, nomeItem, checkboxState, isShared);
    notifyListeners();
  }
}
