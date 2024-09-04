// widgets/todo_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';

class TodoCard extends StatelessWidget {
  final TodoItem todo;
  final Function(TodoItem) onRightSwipe; // 오른쪽 스와이프 동작
  final Function(TodoItem)? onLeftSwipe; // 왼쪽 스와이프 동작 (Optional)
  final bool isDeleted; // 삭제된 항목인지 여부

  TodoCard({
    required this.todo,
    required this.onRightSwipe,
    this.onLeftSwipe,
    this.isDeleted = false, // 기본값은 false (삭제되지 않은 상태)
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.title),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart && onLeftSwipe != null) {
          // 왼쪽 스와이프: 캔슬 또는 복구 동작
          onLeftSwipe!(todo);
        } else if (direction == DismissDirection.startToEnd) {
          // 오른쪽 스와이프: 완료, 삭제 등
          onRightSwipe(todo);
        }
      },
      background: Container(
        color: Colors.green, // 오른쪽 스와이프 시 초록색
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(
          Icons.check, // 완료/복구 아이콘
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: isDeleted ? Colors.blue : Colors.red, // 왼쪽 스와이프 시 색상 구분
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          isDeleted ? Icons.restore : Icons.cancel, // 캔슬 또는 복구 아이콘
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: isDeleted ? Colors.grey[300] : Colors.white, // 삭제된 항목 흐리게 표시
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
      ),
    );
  }
}
