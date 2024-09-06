// widgets/todo_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:intl/intl.dart'; // 날짜 형식 변환을 위해 추가

class TodoCard extends StatelessWidget {
  final TodoItem todo;
  final bool isDeleted;

  TodoCard({
    required this.todo,
    this.isDeleted = false, // 기본값은 false (삭제되지 않은 상태)
  });

  // 날짜 형식을 "월.일 시:분"으로 변환하는 함수
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM.dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // 좌우 0픽셀, 세로 간격 0픽셀 설정
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
        trailing: Text(
          _formatDateTime(todo.lastUpdated), // 상태 변경 시간을 작은 글씨로 표시
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
