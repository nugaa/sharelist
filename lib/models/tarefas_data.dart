import 'package:afazeres/models/postit_info.dart';
import 'package:afazeres/models/tarefas.dart';
import 'package:afazeres/servicos/firebase_firestore_servico.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TarefasData extends ChangeNotifier {
  String nomeLista = '';
  List mlista = [];
  List<Color> listaSoCores = [];
  List<StaggeredTile> _staggeredTiles = <StaggeredTile>[];
  List<PostItInfoWidget> _tiles = <PostItInfoWidget>[];

  Future minhasListas() async {
    mlista = await FirebaseFirestoreServico().obterMinhasListas();
    notifyListeners();
  }

  Future<String> idDaLista(String nomeDaLista) async {
    nomeLista = nomeDaLista;
    /** Obter id do documento **/
    String idDoc;
    idDoc = await FirebaseFirestoreServico().obterIdLista(nomeDaLista);
    /**  ********************* **/
    return idDoc;
  }

  novaLista(String nomeDaLista, String cor) async {
    List allLists = [];
    allLists = await FirebaseFirestoreServico().obterMinhasListas();

    int cont = allLists.length + 1;

    FirebaseFirestoreServico()
        .novaLista(nomeDaLista, cont, cor)
        .then((value) => print('Lista Adicionada'));
  }

  nomeDaListaWidget(String idDoc) {
    return FutureBuilder(
        future: FirebaseFirestoreServico().obterNomeLista(idDoc),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              idDoc,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          var texto = snapshot.data;
          return Text(
            texto,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }

  void removerLista(String nomeLista) async {
    FirebaseFirestoreServico().removerLista(nomeLista);
    notifyListeners();
  }

  void adicionarTarefa(String novaTarefa, String idDaLista) {
    FirebaseFirestoreServico().adicionarTarefa(idDaLista, novaTarefa);
  }

  void removerTarefa(Tarefas tarefa) {
    FirebaseFirestoreServico().removerItemDaLista(nomeLista, tarefa.nome);
    notifyListeners();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code));
  }

  checkboxToggle(String idDoc, String nomeItem, bool checkboxState) async {
    FirebaseFirestoreServico().alterarIsChecked(idDoc, nomeItem, checkboxState);
    notifyListeners();
  }

  List get staggered {
    return _staggeredTiles;
  }

  List get tiles {
    return _tiles;
  }
}
