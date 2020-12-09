import 'package:flutter/material.dart';

class ListasLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Minhas Listas'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar Lista',
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(
          Icons.add,
          size: 40.0,
            color: Colors.white,
        ),
        onPressed: () => print('ADICIONAR LISTA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          children: [
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.yellow,),
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.grey,),
            Container(
              color: Colors.orange,
            ),
            Container(
              color: Colors.black54,),
            Container(
              color: Colors.cyanAccent,
            ),
            Container(
              color: Colors.deepPurple,),
          ],
        ),
      ),
    );
  }
}

/**
    Provider.of<TarefasData>(context, listen: false)
    .minhasListas(context, true);
    **/
// Montar uma lista de widgets com título e algumas tarefas.