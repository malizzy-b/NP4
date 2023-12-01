class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Ativ 01', isDone: true),
      ToDo(id: '02', todoText: 'Ativ 03', isDone: true),
      ToDo(
        id: '03',
        todoText: 'Ativ 04',
      ),
      ToDo(
        id: '04',
        todoText: 'Ativ 05',
      ),
    ];
  }
}
