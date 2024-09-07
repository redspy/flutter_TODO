import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/widgets/todo_list.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<TodoItem> todoList = [];
  List<TodoItem> completedList = [];
  List<TodoItem> deletedList = [];

  @override
  void initState() {
    super.initState();
    _loadTodoData(); // 앱이 시작될 때 저장된 데이터 불러오기
  }

  // 데이터를 로드하는 함수
  void _loadTodoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Todo 리스트 불러오기 (null-safe 처리)
      List<String> savedTodos = prefs.getStringList('todoList') ?? [];
      todoList = savedTodos
          .map((todo) => json.decode(todo))
          .map((map) => TodoItem.fromMap(map ?? {})) // null-safe 처리
          .toList();

      // Completed 리스트 불러오기 (null-safe 처리)
      List<String> savedCompleted = prefs.getStringList('completedList') ?? [];
      completedList = savedCompleted
          .map((todo) => json.decode(todo))
          .map((map) => TodoItem.fromMap(map ?? {})) // null-safe 처리
          .toList();

      // Deleted 리스트 불러오기 (null-safe 처리)
      List<String> savedDeleted = prefs.getStringList('deletedList') ?? [];
      deletedList = savedDeleted
          .map((todo) => json.decode(todo))
          .map((map) => TodoItem.fromMap(map ?? {})) // null-safe 처리
          .toList();
    });
  }

  // 데이터를 저장하는 함수
  void _saveTodoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Todo, Completed, Deleted 리스트 저장
    prefs.setStringList(
        'todoList', todoList.map((todo) => json.encode(todo.toMap())).toList());
    prefs.setStringList('completedList',
        completedList.map((todo) => json.encode(todo.toMap())).toList());
    prefs.setStringList('deletedList',
        deletedList.map((todo) => json.encode(todo.toMap())).toList());
  }

  // 오른쪽 스와이프로 Todo -> Completed 이동
  void _completeTodo(TodoItem todo) {
    setState(() {
      todoList.remove(todo);
      todo.isCompleted = true;
      todo.lastUpdated = DateTime.now(); // 상태 변경 시간 기록
      completedList.add(todo);
    });
    _saveTodoData(); // 데이터 저장
  }

  // 오른쪽 스와이프로 Completed -> Deleted 이동
  void _deleteTodoFromCompleted(TodoItem todo) {
    setState(() {
      completedList.remove(todo);
      todo.lastUpdated = DateTime.now(); // 상태 변경 시간 기록
      deletedList.add(todo);
    });
    _saveTodoData(); // 데이터 저장
  }

  // 오른쪽 스와이프로 Deleted에서 영구 삭제
  void _deleteTodoForever(TodoItem todo) {
    setState(() {
      deletedList.remove(todo);
    });
    _saveTodoData(); // 데이터 저장
  }

  // 왼쪽 스와이프로 Completed -> Todo 이동 (캔슬)
  void _cancelCompleted(TodoItem todo) {
    setState(() {
      completedList.remove(todo);
      todo.isCompleted = false;
      todo.lastUpdated = DateTime.now(); // 상태 변경 시간 기록
      todoList.add(todo);
    });
    _saveTodoData(); // 데이터 저장
  }

  // 왼쪽 스와이프로 Deleted -> Completed 복구
  void _restoreDeleted(TodoItem todo) {
    setState(() {
      deletedList.remove(todo);
      todo.lastUpdated = DateTime.now(); // 상태 변경 시간 기록
      completedList.add(todo);
    });
    _saveTodoData(); // 데이터 저장
  }

  // Todo 리스트에서 순서를 바꾸는 함수
  void _reorderTodos(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final TodoItem item = todoList.removeAt(oldIndex);
      todoList.insert(newIndex, item);
    });
    _saveTodoData(); // 데이터 저장
  }

  // 할일 추가 함수
  void _addTodo() {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800], // 다크 테마 배경
          title: Text(
            "Add New Task",
            style: TextStyle(color: Colors.white), // 다크 테마 글씨
          ),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: "Enter task name"),
            style: TextStyle(color: Colors.white), // 다크 테마 글씨
            autofocus: true, // 입력창에 바로 커서가 가도록 설정
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Add"),
              onPressed: () {
                setState(() {
                  todoList.add(TodoItem(title: taskController.text));
                });
                _saveTodoData(); // 데이터 저장
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 휴지통 버튼을 눌렀을 때 그룹 전체 삭제
  void _deleteGroupItems(String group) {
    setState(() {
      if (group == "Completed") {
        completedList.clear(); // Completed 그룹의 모든 항목을 삭제
      } else if (group == "Deleted") {
        deletedList.clear(); // Deleted 그룹의 모든 항목을 삭제
      }
    });
    _saveTodoData(); // 데이터 저장
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '할 일', // 타이틀 변경
          style: TextStyle(
            color: Colors.white, // 흰색 글씨
            fontWeight: FontWeight.bold, // 굵은 글씨
          ),
        ),
        backgroundColor: Colors.grey[900], // 어두운 AppBar
      ),
      body: Container(
        color: Colors.grey[850], // 배경을 어두운 회색으로 설정
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Todo 그룹
              TodoList(
                title: "To-Do",
                todos: todoList,
                onReorder: _reorderTodos,
                onRightSwipe: _completeTodo,
                disableLeftSwipe: true,
                onDeletePressed: () {}, // To-Do 그룹에서는 삭제 기능 없음
              ),
              // Completed 그룹
              TodoList(
                title: "Completed",
                todos: completedList,
                onReorder: (oldIndex, newIndex) {},
                onRightSwipe: _deleteTodoFromCompleted,
                onLeftSwipe: _cancelCompleted,
                onDeletePressed: () =>
                    _deleteGroupItems("Completed"), // Completed 그룹 삭제
              ),
              // Deleted 그룹
              TodoList(
                title: "Deleted",
                todos: deletedList,
                onReorder: (oldIndex, newIndex) {},
                onRightSwipe: _deleteTodoForever,
                onLeftSwipe: _restoreDeleted,
                isDeleted: true,
                onDeletePressed: () =>
                    _deleteGroupItems("Deleted"), // Deleted 그룹 삭제
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: Colors.teal, // 약간 밝은 색으로 눈에 띄게 설정
        child: Icon(Icons.add),
      ),
    );
  }
}
