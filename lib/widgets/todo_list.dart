// widgets/todo_list.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/widgets/todo_card.dart';

class TodoList extends StatelessWidget {
  final String title;
  final List<TodoItem> todos;
  final Function(int, int) onReorder;
  final Function(TodoItem) onRightSwipe;
  final Function(TodoItem)? onLeftSwipe;
  final bool isDeleted;
  final bool disableLeftSwipe; // 왼쪽 스와이프 비활성화 여부

  TodoList({
    required this.title,
    required this.todos,
    required this.onReorder,
    required this.onRightSwipe,
    this.onLeftSwipe,
    this.isDeleted = false,
    this.disableLeftSwipe = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 그룹명 영역에 회색 배경 적용, 세로 여백을 줄이고 가로는 꽉 채움
        Container(
          width: double.infinity, // 가로 방향으로 화면을 꽉 채움
          color: Colors.grey[300], // 배경색을 회색으로 설정
          padding:
              EdgeInsets.symmetric(vertical: 5, horizontal: 10), // 세로 여백 줄임
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold, // 그룹명을 더 진하게
              color: Colors.black87, // 좀 더 진한 색으로 설정
            ),
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
              key: ValueKey(todo.title),
              direction: disableLeftSwipe
                  ? DismissDirection.startToEnd
                  : DismissDirection.horizontal,
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
                HapticFeedback.heavyImpact();
                HapticFeedback.vibrate(); // 강한 진동과 더 긴 진동

                if (direction == DismissDirection.endToStart &&
                    onLeftSwipe != null) {
                  onLeftSwipe!(todo);
                } else if (direction == DismissDirection.startToEnd) {
                  onRightSwipe(todo);
                }
              },
              child: ListTile(
                key: ValueKey(todo),
                title: TodoCard(todo: todo, isDeleted: isDeleted),
              ),
            );
          }),
        ),
      ],
    );
  }
}
