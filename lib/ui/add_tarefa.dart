import 'package:afazeres/models/tarefas_data.dart';
import 'package:afazeres/ui/tarefas_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTarefa extends StatefulWidget {
  @override
  _AddTarefaState createState() => _AddTarefaState();
}

class _AddTarefaState extends State<AddTarefa> {
  String novaTarefa;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Adicionar Tarefa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Insira aqui...',
              ),
              onChanged: (texto) {
                novaTarefa = texto;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RaisedButton(
                color: Colors.lightBlueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onPressed: novaTarefa == null ||
                        novaTarefa == "" ||
                        novaTarefa.trim().length < 2
                    ? null
                    : () {
                        Provider.of<TarefasData>(context, listen: false)
                            .adicionarTarefa(novaTarefa);
                        Navigator.pop(context);
                      },
              ),
            )
          ],
        ),
      ),
    );
  }
}
