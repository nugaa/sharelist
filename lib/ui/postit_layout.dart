import 'package:afazeres/models/tarefas_data.dart';
import 'package:afazeres/servicos/firebase_firestore_servico.dart';
import 'package:afazeres/widgets/dialog_nova_lista.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostIt_Layout extends StatefulWidget {
  @override
  _PostIt_LayoutState createState() => _PostIt_LayoutState();
}

class _PostIt_LayoutState extends State<PostIt_Layout> {
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
        onPressed: () async {
          await mostrarDialogNovaLista(context);
        },
      ),
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: FirebaseFirestoreServico().streamNomeLista(),
      ),
    );
  }
}
