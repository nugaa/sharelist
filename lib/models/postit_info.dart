import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostItInfo {
  tilesAdd({Color cor, String nome, String email, bool isShared}) =>
      PostItInfoWidget(
        backgroundColor: cor,
        nomeDaLista: nome,
        email: email,
        isShared: isShared,
      );
}

class PostItInfoWidget extends StatelessWidget {
  PostItInfoWidget(
      {this.backgroundColor, this.nomeDaLista, this.email, this.isShared});
  final Color backgroundColor;
  final String nomeDaLista;
  final String email;
  final bool isShared;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 10.0,
      color: backgroundColor.withOpacity(0.6),
      child: InkWell(
        onTap: () async {
          Navigator.of(context).pushNamed('/tarefas', arguments: {
            'email': email,
            'nome': nomeDaLista,
            'cor': backgroundColor,
            'isShared': isShared,
          });
        },
        child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Text(
                        nomeDaLista,
                        style: TextStyle(
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.black45,
                        ),
                      ),
                      Text(
                        nomeDaLista,
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: backgroundColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
