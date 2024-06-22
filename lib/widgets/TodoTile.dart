import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Todo.dart';
import '../models/TodoState.dart';
import '../todo_page.dart';

class TodoTile extends StatelessWidget {

  Todo todo;
  void Function()? onPressed;

  TodoTile({required Todo this.todo, this.onPressed });


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
  }
}