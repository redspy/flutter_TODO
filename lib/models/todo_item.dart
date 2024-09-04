// models/todo_item.dart
class TodoItem {
  final String title;
  bool isCompleted;

  TodoItem({required this.title, this.isCompleted = false});

  // TodoItem을 Map으로 변환 (JSON 형식 저장을 위해)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Map 데이터를 TodoItem 객체로 변환
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }
}
