import 'package:afazeres/models/tarefas_data.dart';
import 'package:afazeres/widgets/dialog_nova_lista.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dialog_adicionarUserPartilha.dart';

class Meu_BottomBar extends StatelessWidget {
  Meu_BottomBar({this.cor, this.email, this.nomeLista, this.isShared});
  Color cor;
  String email;
  String nomeLista;
  bool isShared;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: !isShared
            ? rowPessoal(context, cor, email, nomeLista, isShared)
            : rowPartilha(context, cor, email, nomeLista, isShared),
      ),
    );
  }
}

Row rowPessoal(
  BuildContext context,
  Color cor,
  String email,
  String nomeLista,
  bool isShared,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        tooltip: 'Ver listas',
        icon: Icon(
          Icons.list_alt,
          size: 30.0,
          color: Colors.white70,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      SizedBox(
        width: 1.0,
        height: 30.0,
        child: Container(
          color: Colors.white24,
        ),
      ),
      IconButton(
        tooltip: 'Adicionar nova lista',
        icon: Icon(
          Icons.playlist_add,
          size: 35.0,
          color: Colors.white70,
        ),
        onPressed: () {
          mostrarDialogNovaLista(context, email, isShared);
        },
      ),
      SizedBox(
        width: 1.0,
        height: 30.0,
        child: Container(
          color: Colors.white24,
        ),
      ),
      IconButton(
        tooltip: 'Partilhar lista',
        icon: Icon(
          Icons.share,
          color: Colors.white70,
        ),
        onPressed: () async {
          var result = await mostrarDialogAdicionarUserPartilha(
              ctx: context,
              meuEmail: email,
              nomeLista: nomeLista,
              cor: cor,
              check: false);

          if (result == true) {
            String id;
            id = await Provider.of<TarefasData>(context, listen: false)
                .idDaLista(email, nomeLista, false);
            if (id.isNotEmpty) {
              Provider.of<TarefasData>(context, listen: false)
                  .removerLista(email, id, false);
              Navigator.popUntil(context, ModalRoute.withName('/postit'));
            }
          } else {
            Flushbar(
              duration: Duration(seconds: 2),
              title: 'Partilha cancelada',
              message: 'A lista não foi partilhada',
            ).show(context);
          }
        },
      ),
    ],
  );
}

Row rowPartilha(
  BuildContext context,
  Color cor,
  String email,
  String nomeLista,
  bool isShared,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        tooltip: 'Ver listas',
        icon: Icon(
          Icons.list_alt,
          size: 30.0,
          color: Colors.white70,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      SizedBox(
        width: 1.0,
        height: 30.0,
        child: Container(
          color: Colors.white24,
        ),
      ),
      IconButton(
        tooltip: 'Adicionar utilizador',
        icon: Icon(
          Icons.person_add,
          color: Colors.white70,
        ),
        onPressed: () async {
          var result = await mostrarDialogAdicionarUserPartilha(
              ctx: context,
              meuEmail: email,
              nomeLista: nomeLista,
              cor: cor,
              check: true);

          if (result == true) {
          } else {
            Flushbar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
              title: 'Aviso',
              message: 'O utilizador não foi adicionado a esta lista',
            ).show(context);
          }
        },
      ),
    ],
  );
}
