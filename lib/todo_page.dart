import 'package:flutter/material.dart';
import 'models/Todo.dart';

class TodoPage extends StatelessWidget {
  final Todo todo;

  const TodoPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detail View'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Name: ${todo.name}'),
            Text('Description: ${todo.description}'),
            Text('Status: ${todo.state}'),
            Text('Deadline: ${todo.deadline?.format()??'No Deadline'}')
          ],
        ),
      ),
    );
  }
}
