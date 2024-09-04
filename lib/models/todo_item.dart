// models/todo_item.dart
class TodoItem {
  final String title;
  bool isCompleted;

  TodoItem({required this.title, this.isCompleted = false});
}
