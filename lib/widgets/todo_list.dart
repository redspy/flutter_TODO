// widgets/todo_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/widgets/todo_card.dart';

class TodoList extends StatelessWidget {
  final String title;
  final List<TodoItem> todos;
  final Function(int, int) onReorder;
  final Function(TodoItem) onRightSwipe;
  final Function(TodoItem)? onLeftSwipe;
  final bool isDeleted;

  TodoList({
    required this.title,
    required this.todos,
    required this.onReorder,
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
        ReorderableListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            onReorder(oldIndex, newIndex); // 순서 변경 콜백
          },
          children: List.generate(todos.length, (index) {
            final todo = todos[index];
            return Dismissible(
              key: ValueKey(todo.title), // 고유 키 부여
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.check, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: isDeleted ? Colors.blue : Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  isDeleted ? Icons.restore : Icons.cancel,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart &&
                    onLeftSwipe != null) {
                  // 왼쪽 스와이프
                  onLeftSwipe!(todo);
                } else if (direction == DismissDirection.startToEnd) {
                  // 오른쪽 스와이프
                  onRightSwipe(todo);
                }
              },
              child: ListTile(
                key: ValueKey(todo), // ReorderableListView에서 사용하는 키
                title: TodoCard(todo: todo, isDeleted: isDeleted),
              ),
            );
          }),
        ),
      ],
    );
  }
}
