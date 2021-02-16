import 'package:afazeres/servicos/firestore_listas.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

mostrarDialogAdicionarUserPartilha(
    {BuildContext ctx,
    String meuEmail,
    String nomeLista,
    Color cor,
    bool check}) {
  FirestoreListas _firestoreListas = FirestoreListas();
  String outroEmail;
  return showDialog(
      context: ctx,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      color: cor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Partilhar com...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'Email com quem quer partilhar:',
                                labelStyle: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              onChanged: (value) {
                                outroEmail = value;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  color: cor,
                                  onPressed: () async {
                                    bool permitir = await _firestoreListas
                                        .permitirPartilhar(
                                      meuEmail,
                                      outroEmail,
                                      nomeLista,
                                      check,
                                    );
                                    if (permitir) {
                                      check = true;
                                      var result = await _firestoreListas
                                          .adicionarUserPartilha(
                                        meuEmail: meuEmail,
                                        emailOutro: outroEmail,
                                        nomeLista: nomeLista,
                                        cor: cor.toString(),
                                      );
                                      if (result == true) {
                                        Navigator.of(context).pop(true);
                                        return Flushbar(
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.green[800],
                                          title: 'Informação',
                                          message:
                                              'Partilhou a lista com $outroEmail',
                                        ).show(context);
                                      } else {
                                        return Flushbar(
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.redAccent,
                                          title: 'Aviso!',
                                          message: 'Introduza um email válido.',
                                        ).show(context);
                                      }
                                    } else {
                                      return Flushbar(
                                              duration: Duration(seconds: 5),
                                              backgroundColor: Colors.redAccent,
                                              title: 'Aviso!',
                                              message:
                                                  'Não foi possível partilhar esta lista.\n'
                                                  'Já se encontra numa lista partilhada com o nome $nomeLista.')
                                          .show(context);
                                    }
                                  },
                                  child: Text(
                                    'Partilhar',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  color: cor,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
