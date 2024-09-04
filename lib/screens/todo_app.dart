// screens/todo_app.dart
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
    _loadTodoData(); // 앱 시작 시 저장된 데이터를 불러옴
  }

  // 데이터를 로드하는 함수
  void _loadTodoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Todo 리스트 불러오기
      List<String> savedTodos = prefs.getStringList('todoList') ?? [];
      todoList = savedTodos
          .map((todo) => TodoItem.fromMap(json.decode(todo)))
          .toList();

      // Completed 리스트 불러오기
      List<String> savedCompleted = prefs.getStringList('completedList') ?? [];
      completedList = savedCompleted
          .map((todo) => TodoItem.fromMap(json.decode(todo)))
          .toList();

      // Deleted 리스트 불러오기
      List<String> savedDeleted = prefs.getStringList('deletedList') ?? [];
      deletedList = savedDeleted
          .map((todo) => TodoItem.fromMap(json.decode(todo)))
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
      completedList.add(todo);
    });
    _saveTodoData(); // 데이터 저장
  }

  // 오른쪽 스와이프로 Completed -> Deleted 이동
  void _deleteTodoFromCompleted(TodoItem todo) {
    setState(() {
      completedList.remove(todo);
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
      todoList.add(todo);
    });
    _saveTodoData(); // 데이터 저장
  }

  // 왼쪽 스와이프로 Deleted -> Completed 복구
  void _restoreDeleted(TodoItem todo) {
    setState(() {
      deletedList.remove(todo);
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
          title: Text("Add New Task"),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: "Enter task name"),
          ),
          actions: <Widget>[
            ElevatedButton(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Todo 그룹 (드래그 앤 드롭 기능 포함)
            TodoList(
              title: "To-Do",
              todos: todoList,
              onReorder: _reorderTodos,
              onRightSwipe: _completeTodo,
              disableLeftSwipe: true, // 왼쪽 스와이프 비활성화
            ),
            // Completed 그룹
            TodoList(
              title: "Completed",
              todos: completedList,
              onReorder: (oldIndex, newIndex) {},
              onRightSwipe: _deleteTodoFromCompleted,
              onLeftSwipe: _cancelCompleted,
            ),
            // Deleted 그룹
            TodoList(
              title: "Deleted",
              todos: deletedList,
              onReorder: (oldIndex, newIndex) {},
              onRightSwipe: _deleteTodoForever,
              onLeftSwipe: _restoreDeleted,
              isDeleted: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: Icon(Icons.add),
      ),
    );
  }
}
