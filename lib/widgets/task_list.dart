import 'package:afazeres/models/tarefas_data.dart';
import 'package:afazeres/widgets/list_checkbox_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  TaskList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<TarefasData>(
      builder: (context, tarefaData, child) {
        return ListView.builder(
          itemCount: tarefaData.tarefasCont,
          itemBuilder: (context, index) {
            final tarefa = tarefaData.listaTarefas[index];
            return Dismissible(
              key: Key(tarefa.nome),
              background: Container(
                color: Colors.redAccent,
              ),
              onDismissed: (direcao) {
                tarefaData.removerTarefa(tarefa);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: ListCheckboxTile(
                  isChecked: tarefa.tarefaCompleta,
                  nomeTarefa: tarefa.nome,
                  toggleIt: (checkboxState) {
                    tarefaData.checkboxToggle(tarefa);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
