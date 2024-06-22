import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/my_home_page.dart';

import '../models/Todo.dart';
import '../models/TodoState.dart';
import '../todo_page.dart';

class TodoTile extends StatelessWidget {

  Todo todo;
  void Function()? onPressed;

  TodoTile({required Todo this.todo, this.onPressed });

  Future<void> deleteTodo(Todo todoToDelete, BuildContext context) async {
  final request = ModelMutations.delete(todoToDelete);
  final response = await Amplify.API.mutate(request: request).response;
  safePrint('Response: $response');
  _navigateAndDisplaySelection(context);
}

Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Hackathon Todo App')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        onPressed: onPressed,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => {deleteTodo(todo, context)},
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
  }
}