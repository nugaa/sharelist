import 'package:afazeres/models/tarefas_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mostrarDialogNovaLista(BuildContext context) {
  String novaListaNome;
  return showDialog(
      context: context,
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
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Adicionar Nova Lista',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                labelText: 'Nome da lista...',
                                labelStyle: TextStyle(
                                  fontSize: 18.0,
                                )),
                            onChanged: (value) {
                              novaListaNome = value;
                            },
                          ),
                          RaisedButton(
                            elevation: 15.0,
                            color: Colors.lightBlueAccent,
                            onPressed: () {
                              Provider.of<TarefasData>(context, listen: false)
                                  .novaLista(novaListaNome);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Adicionar',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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
