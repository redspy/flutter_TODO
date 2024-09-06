// widgets/todo_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';

class TodoCard extends StatelessWidget {
  final TodoItem todo;
  final bool isDeleted;

  TodoCard({
    required this.todo,
    this.isDeleted = false, // 기본값은 false (삭제되지 않은 상태)
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // 좌우 0픽셀, 세로 간격 0픽셀 설정
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      // 모서리 둥글기 값을 0으로 설정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // 둥글기 0
      ),
      color: isDeleted ? Colors.grey[300] : Colors.white, // 삭제된 항목은 흐리게
      child: ListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: isDeleted ? Colors.grey : Colors.black, // 삭제된 항목은 흐리게
          ),
        ),
      ),
    );
  }
}
