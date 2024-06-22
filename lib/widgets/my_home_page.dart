import 'package:flutter/material.dart';
import 'package:myapp/models/ModelProvider.dart';
import 'package:myapp/todo_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [
    Todo(
        name: 'test',
        description: 'Ist es ein Raum? Ist es ein Berg?',
        state: TodoState.NotStarted),
    Todo(
        name: 'Hallo',
        description: 'Ist es ein Raum? Ist es ein Berg?',
        state: TodoState.NotStarted)
  ];

  void _incrementCounter() {
    setState(() {
      todos.add(Todo(
        name: 'New task',
        description: 'Beschreibung des neuen Raums',
        state: TodoState.NotStarted,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: todos.map((todo) {
            return ListTile(
              title: Text(todo.name),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TodoPage(key: ValueKey(todo.hashCode), todo: todo)),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add room',
        child: const Icon(Icons.add),
      ),
    );
  }
}
