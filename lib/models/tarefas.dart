class Tarefas {
  final String nome;
  bool tarefaCompleta;

  Tarefas({this.nome, this.tarefaCompleta = false});

  void tarefaToggle() {
    tarefaCompleta = !tarefaCompleta;
  }
}
