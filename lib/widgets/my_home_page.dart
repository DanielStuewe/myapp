// ignore_for_file: prefer_const_constructors

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/ModelProvider.dart';
import 'package:myapp/todo_page.dart';
import 'package:myapp/widgets/TodoTile.dart';
import 'package:myapp/widgets/input_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> _todos = [];

  void _incrementCounter() {
    setState(() {
      _todos.add(Todo(
        name: 'New task',
        description: 'Beschreibung des neuen Tasks',
        state: TodoState.NotStarted,
      ));
    });
  }

  Future<void> deleteTodo(Todo todoToDelete) async {
  final request = ModelMutations.delete(todoToDelete);
  final response = await Amplify.API.mutate(request: request).response;
  safePrint('Response: $response');
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
        _todos = todos!.whereType<Todo>().toList();
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
            return TodoTile(
              todo: todo,
              onPressed: () => setState(() {
                _todos.add(todo.copyWith(state: TodoState.InProgress));
              }),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                InputPage(key: UniqueKey()))), //_incrementCounter,
        tooltip: 'Add To Do',
        child: const Icon(Icons.add),
      ),
    );
  }
}
