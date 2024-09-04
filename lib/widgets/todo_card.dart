// widgets/todo_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';

class TodoCard extends StatelessWidget {
  final TodoItem todo;
  final Function(TodoItem) onToggleCompletion;

  TodoCard({required this.todo, required this.onToggleCompletion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            onToggleCompletion(todo);
          },
        ),
      ),
    );
  }
}
