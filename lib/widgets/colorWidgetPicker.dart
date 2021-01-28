import 'package:afazeres/models/tarefas_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mostrarCoresPicker(BuildContext context, String nomeLista) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        corCA(context, Colors.red, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.yellowAccent, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.lightGreen, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.blueGrey, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.redAccent, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.brown, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.teal, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.blue, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.pinkAccent, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.orange, nomeLista),
        SizedBox(
          width: 5.0,
        ),
        corCA(context, Colors.amber, nomeLista),
      ],
    ),
  );
}

InkWell corCA(BuildContext ctx, Color cor, String nome) => InkWell(
      onTap: () {
        if (nome != null && nome.length >= 3) {
          Provider.of<TarefasData>(ctx, listen: false)
              .novaLista(nome, cor.toString());
          print(nome);
          Navigator.of(ctx).popAndPushNamed('/first', arguments: nome);
        } else {
          Flushbar(
            backgroundColor: Colors.blueAccent,
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
