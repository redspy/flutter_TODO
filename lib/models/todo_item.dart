// models/todo_item.dart
class TodoItem {
  final String title;
  bool isCompleted;
  DateTime lastUpdated; // 상태 변경 시간 필드 추가

  TodoItem({
    required this.title,
    this.isCompleted = false,
    DateTime? lastUpdated, // 상태 변경 시간을 선택적으로 초기화
  }) : lastUpdated = lastUpdated ?? DateTime.now(); // 현재 시간으로 초기화

  // TodoItem을 Map으로 변환 (JSON 저장을 위해)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'lastUpdated': lastUpdated.toIso8601String(), // 상태 변경 시간을 저장
    };
  }

  // Map 데이터를 TodoItem 객체로 변환 (null-safe 처리 추가)
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      title: map['title'] ?? '', // 제목이 없을 경우 기본값 설정
      isCompleted: map['isCompleted'] ?? false, // isCompleted가 없을 경우 false
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated']) // 상태 변경 시간 변환
          : DateTime.now(), // lastUpdated가 없을 경우 현재 시간
    );
  }
}
