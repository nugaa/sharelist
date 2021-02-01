import 'package:afazeres/widgets/dialog_nova_lista.dart';
import 'package:flutter/material.dart';

class Meu_BottomBar extends StatelessWidget {
  Meu_BottomBar(this.cor);
  Color cor;
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              tooltip: 'Minhas listas',
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
                mostrarDialogNovaLista(context);
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
                //TODO: partilhar lista
              },
            ),
          ],
        ),
      ),
    );
  }
}
