import 'package:afazeres/models/tarefas_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTarefa extends StatefulWidget {
  AddTarefa(this.idDaLista);
  final String idDaLista;
  @override
  _AddTarefaState createState() => _AddTarefaState();
}

class _AddTarefaState extends State<AddTarefa> {
  String novaTarefa;
  String id;

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
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Insira aqui...',
              ),
              onSubmitted: (texto) async {
                novaTarefa = texto;
                if (novaTarefa != null ||
                    novaTarefa != "" ||
                    novaTarefa.trim().length > 2) {
                  String nomeDaLista = widget.idDaLista;
                  if (nomeDaLista != null && nomeDaLista.isNotEmpty) {
                    Provider.of<TarefasData>(context, listen: false)
                        .adicionarTarefa(novaTarefa, nomeDaLista);
                  }
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
