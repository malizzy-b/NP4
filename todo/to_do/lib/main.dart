import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web/material.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  //Controllers são usadas quando precisamos resgatar ou modificar uma propriedade de um widget
  final _textController = TextEditingController();

  //Lista responsável por popular nosso ListView
  List _toDoList = [];

  //Caso o usuário remover uma tarefa, ela ficará em memória nesta variável por um tempo
  late Map<String, dynamic> _lastRemoved;

  late int _lastRemovedPos;

  void addToDo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = _textController.text;
      newTodo["ok"] = false;
      _toDoList.add(newTodo);
      _textController.text = '';
    });
  }

  void _dismissToDo(
      DismissDirection direction, BuildContext context, int index) {
    setState(() {
      _lastRemoved = Map.from(_toDoList[index]);
      _lastRemovedPos = index;
      _toDoList.removeAt(index);

      final snack = SnackBar(
        content: Text('Tarefa \"${_lastRemoved["title"]}\" removida!'),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              _toDoList.insert(_lastRemovedPos, _lastRemoved);
            });
          },
        ),
        duration: Duration(seconds: 5),
      );
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ToDo Flutter'),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          labelText: 'Nova tarefa',
                          labelStyle: TextStyle(color: Colors.grey)),
                    )),
                    ElevatedButton(
                      color: Colors.indigo,
                      child: Text('Adicionar'),
                      textColor: Colors.white,
                      onPressed: addToDo,
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: _toDoList.length,
                    itemBuilder: itemBuilder))
          ],
        ));
  }

  Widget itemBuilder(context, index) {
    //Widget responsável por permitir dismiss
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      //A propriedade "background" representa o fundo da nossa tile, o fundo em si não possui ações
      //As ações estão no evento onDismissed
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(IconData(0xe900, fontFamily: 'GalleryIcons'), color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
          });
        },
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
      ),
      onDismissed: (direction) {
        _dismissToDo(direction, context, index);
      },
    );
  }
}