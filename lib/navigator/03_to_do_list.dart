import 'package:flutter/material.dart';

class Todo{
  final String title;
  final String description;

  Todo(this.title, this.description);
}

class TodoScreen extends StatelessWidget{
  static const String routeName = '/navigator/to_do_list';

  final List<Todo> todos;

  TodoScreen({
    Key key,
    this.todos
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todos'),),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(todos[index].title),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(todo: todos[index],)
                  )
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget{
  final Todo todo;

  DetailScreen({
    Key key,
    @required this.todo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Center(
        child: Text(todo.description),
      ),
    );
  }
}