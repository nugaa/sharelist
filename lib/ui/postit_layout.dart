import 'dart:async';

import 'package:afazeres/servicos/conexao_bloc.dart';
import 'package:afazeres/servicos/firebase_firestore_servico.dart';
import 'package:afazeres/widgets/dialog_nova_lista.dart';
import 'package:afazeres/widgets/mostrarAvisoWidget.dart';
import 'package:flutter/material.dart';

class PostIt_Layout extends StatefulWidget {
  @override
  _PostIt_LayoutState createState() => _PostIt_LayoutState();
}

class _PostIt_LayoutState extends State<PostIt_Layout> {
  StreamSubscription _conexaoAlteradaStream;
  bool isOff = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.withOpacity(0.5),
        child: Icon(
          Icons.add,
          size: 30.0,
          color: Colors.white,
        ),
        onPressed: isOff == false
            ? () async {
                await mostrarDialogNovaLista(context);
              }
            : null,
      ),
      backgroundColor: Colors.blueGrey[300],
      body: SafeArea(
        child: isOff == false
            ? FirebaseFirestoreServico().streamNomeLista()
            : SafeArea(child: waitConnWidget(context)),
      ),
    );
  }
}
