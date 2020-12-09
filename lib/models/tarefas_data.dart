import 'dart:collection';
import 'package:afazeres/models/tarefas.dart';
import 'package:afazeres/servicos/firebase_firestore_servico.dart';
import 'package:afazeres/widgets/dialog_listas.dart';
import 'package:flutter/material.dart';

class TarefasData extends ChangeNotifier {
  List<Tarefas> _listaTarefas = [];
  String nomeLista = '';
  List mlista = [];

  void minhasListas(BuildContext contexto, bool isDismiss) async {
    mlista = await FirebaseFirestoreServico().obterMinhasListas();
    mostrarDialogListas(contexto, mlista, isDismiss);
    notifyListeners();
  }

  void mudarLista(String nomeDaLista) async {
    nomeLista = nomeDaLista;
    _listaTarefas.clear();
    List listaItems = [];
    listaItems =
        await FirebaseFirestoreServico().obterItemsDaLista(nomeDaLista);

    for (int i = 0; i < listaItems.length; i++) {
      _listaTarefas.add(Tarefas(nome: listaItems[i]));
    }
    notifyListeners();
  }

  void novaLista(String nomeDaLista) {
    FirebaseFirestoreServico()
        .novaLista(nomeDaLista)
        .then((value) => print('Lista Adicionada'));
  }

  void removerLista() async {
    FirebaseFirestoreServico().removerLista(nomeLista);
    nomeLista = '';
    _listaTarefas.clear();
    mlista = await FirebaseFirestoreServico().obterMinhasListas();
    notifyListeners();
  }

  void adicionarTarefa(String novaTarefa) {
    FirebaseFirestoreServico()
        .adicionarTarefa(nomeLista, novaTarefa)
        .then((value) => print('Tarefa adicionada'));
    _listaTarefas.add(Tarefas(nome: novaTarefa));
    notifyListeners();
  }

  void removerTarefa(Tarefas tarefa) {
    FirebaseFirestoreServico().removerItemDaLista(nomeLista, tarefa.nome);
    _listaTarefas.remove(tarefa);
    notifyListeners();
  }

  void checkboxToggle(Tarefas tarefa) {
    tarefa.tarefaToggle();
    notifyListeners();
  }

  UnmodifiableListView<Tarefas> get listaTarefas {
    return UnmodifiableListView(_listaTarefas);
  }

  int get tarefasCont {
    return _listaTarefas.length;
  }
}
