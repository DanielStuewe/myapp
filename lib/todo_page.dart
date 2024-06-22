import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/Todo.dart';


String truncate(String text, [int limit = 100, String omission = '...']) =>
    (text.length >= limit)
        ? text.replaceRange(limit, text.length, omission)
        : text;

String formatDeadline(TemporalDateTime? deadline) {
  safePrint('TodoPage deadline $deadline');
  if (deadline == null) {
    return 'No Deadline';
  }

  final DateFormat formatter = DateFormat('yMMMMEEEEd', 'de_DE');
  return formatter.format(deadline.getDateTimeInUtc()) ;
}

class TodoPage extends StatelessWidget {
  final Todo todo;

  const TodoPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    safePrint('TodoPage TODO $todo');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detail View'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Name: ${todo.name}'),
            Text('Description: ${truncate(todo.description ?? '')}'),
            Text('Status: ${todo.state}'),
            Text('Deadline: ${formatDeadline(todo.deadline)}')
          ],
        ),
      ),
    );
  }
}
