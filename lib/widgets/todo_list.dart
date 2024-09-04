// widgets/todo_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/widgets/todo_card.dart';

class TodoList extends StatelessWidget {
  final String title;
  final List<TodoItem> todos;
  final Function(TodoItem) onToggleCompletion;

  TodoList({
    required this.title,
    required this.todos,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return TodoCard(
              todo: todos[index],
              onToggleCompletion: onToggleCompletion,
            );
          },
        ),
      ],
    );
  }
}
