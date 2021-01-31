import 'dart:async';

import 'package:afazeres/models/tarefas_data.dart';
import 'package:afazeres/servicos/conexao_bloc.dart';
import 'package:afazeres/servicos/firebase_firestore_servico.dart';
import 'package:afazeres/ui/add_tarefa.dart';
import 'package:afazeres/widgets/dialog_remover_lista.dart';
import 'package:afazeres/widgets/meu_bottombar.dart';
import 'package:afazeres/widgets/mostrarAvisoWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TarefasLayout extends StatefulWidget {
  @override
  _TarefasLayoutState createState() => _TarefasLayoutState();
}

class _TarefasLayoutState extends State<TarefasLayout> {
  StreamSubscription _conexaoAlteradaStream;
  bool isOff = false;
  @override
  void initState() {
    super.initState();
    Conexao_Bloc conexaoStatus = Conexao_Bloc.getInstance();
    _conexaoAlteradaStream =
        conexaoStatus.conexaoStream.listen(conexaoAlterada);
  }

  void conexaoAlterada(dynamic temConexao) {
    setState(() {
      isOff = !temConexao;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _conexaoAlteradaStream.cancel();
  }

  Widget build(BuildContext context) {
    final String nomePassado =
        ModalRoute.of(context).settings.arguments as String;
    return isOff == false
        ? Scaffold(
            backgroundColor: Colors.lightBlueAccent,
            floatingActionButton: FloatingActionButton(
              tooltip: 'Adicionar nova tarefa',
              backgroundColor: Colors.lightBlueAccent,
              child: Icon(
                Icons.add,
                size: 40.0,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTarefa(nomePassado),
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar: Meu_BottomBar(),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 20.0,
                      bottom: 15.0,
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.list,
                              color: Colors.lightBlueAccent,
                              size: 45.0,
                            ),
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: nomePassado.length > 2
                                    ? Text(
                                        nomePassado,
                                        style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Provider.of<TarefasData>(context)
                                        .nomeDaLista(nomePassado),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: IconButton(
                                  iconSize: 30.0,
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    bool result =
                                        await mostrarDialogRemoverLista(
                                            context);
                                    if (result == true) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: FirebaseFirestoreServico()
                          .streamBuilderTarefas(nomePassado),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.blueGrey[300],
            body: waitConnWidget(context),
          );
  }
}
