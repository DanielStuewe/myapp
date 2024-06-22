// ignore_for_file: prefer_const_constructors

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
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
  List<Todo> _todos = [
    Todo(
        name: 'test',
        description: 'Ist es ein Raum? Ist es ein Berg?',
        state: TodoState.NotStarted),
    Todo(
        name: 'Hallo',
        description: 'Ist es ein Raum? Ist es ein Berg?',
        state: TodoState.NotStarted,
        deadline: TemporalDateTime.fromString('2024-06-22T17:00Z'))
  ];

  void _incrementCounter() {
    setState(() {
      _todos.add(Todo(
        name: 'New task',
        description: 'Beschreibung des neuen Raums',
        state: TodoState.NotStarted,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  Future<void> _refreshTodos() async {
    try {
      final request = ModelQueries.list(Todo.classType);
      final response = await Amplify.API.query(request: request).response;

      final todos = response.data?.items;
      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        //_todos = todos!.whereType<Todo>().toList();
        safePrint(_todos);
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
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
          children: _todos.map((todo) {
            final leadingIcon = switch (todo.state) {
              TodoState.InProgress => Icon(Icons.change_circle),
              TodoState.NotStarted => Icon(Icons.circle_outlined),
              _ => Icon(Icons.check_circle_outline)
            };
            const Icon(Icons.check_box);
            return ListTile(
              title: Text(todo.name),
              leading: IconButton(
                icon: leadingIcon,
                onPressed: () => {
                  setState(() {
                    _todos.add(todo.copyWith(state: TodoState.InProgress));
                  })
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => {},
              ),
              subtitle: todo.description != null
                  ? Text(truncate(todo.description!))
                  : null,
              // onTap: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           TodoPage(key: ValueKey(todo.hashCode), todo: todo)),
              // ),
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
