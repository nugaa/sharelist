import 'package:afazeres/models/tarefas_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mostrarCoresPicker(BuildContext context, String nomeLista, email) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        corCA(context, Colors.red, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.indigoAccent, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.lightGreen, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.blueGrey, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.redAccent, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.brown, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.teal, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.blue, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.pinkAccent, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.orange, nomeLista, email),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.amber, nomeLista, email),
      ],
    ),
  );
}

InkWell corCA(BuildContext ctx, Color cor, String nome, String email) =>
    InkWell(
      onTap: () {
        if (nome != null && nome.length >= 3) {
          Provider.of<TarefasData>(ctx, listen: false)
              .novaLista(email, nome, cor.toString());
          Navigator.of(ctx).popAndPushNamed('/tarefas', arguments: {
            'nome': nome,
            'cor': cor,
            'email': email,
            'isShared': false,
          });
        } else {
          Flushbar(
            backgroundColor: Colors.redAccent,
            title: 'Nome negado',
            message: 'Por favor, introduza um nome para a lista',
            duration: Duration(seconds: 3),
          ).show(ctx);
        }
      },
      child: CircleAvatar(
        radius: 16.0,
        backgroundColor: cor,
      ),
    );
