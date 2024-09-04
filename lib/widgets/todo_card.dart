// widgets/todo_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';

class TodoCard extends StatelessWidget {
  final TodoItem todo;
  final Function(TodoItem) onToggleCompletion;
  final bool isDeleted; // 삭제된 항목인지 여부

  TodoCard({
    required this.todo,
    required this.onToggleCompletion,
    this.isDeleted = false, // 기본값은 false (삭제되지 않은 상태)
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.title),
      onDismissed: (direction) {
        onToggleCompletion(todo); // 스와이프 시 완료/미완료 상태 변경 또는 삭제
      },
      background: Container(
        color: isDeleted ? Colors.red : Colors.green, // 삭제된 항목은 빨간색 배경
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(
          isDeleted ? Icons.delete : Icons.check,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          isDeleted ? Icons.delete_forever : Icons.close,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: isDeleted ? Colors.grey[300] : Colors.white, // 삭제된 항목은 흐리게
        child: ListTile(
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: isDeleted ? Colors.grey : Colors.black, // 삭제된 항목 흐리게
            ),
          ),
        ),
      ),
    );
  }
}
