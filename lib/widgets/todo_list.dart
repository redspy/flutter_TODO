// widgets/todo_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/widgets/todo_card.dart';

class TodoList extends StatelessWidget {
  final String title;
  final List<TodoItem> todos;
  final Function(TodoItem) onRightSwipe;
  final Function(TodoItem)? onLeftSwipe; // 왼쪽 스와이프 동작 (Optional)
  final bool isDeleted;

  TodoList({
    required this.title,
    required this.todos,
    required this.onRightSwipe,
    this.onLeftSwipe,
    this.isDeleted = false,
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
              onRightSwipe: onRightSwipe,
              onLeftSwipe: onLeftSwipe,
              isDeleted: isDeleted,
            );
          },
        ),
      ],
    );
  }
}
