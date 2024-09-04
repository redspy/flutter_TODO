// screens/todo_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/widgets/todo_list.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<TodoItem> todoList = [
    TodoItem(title: "Go to gym"),
    TodoItem(title: "Buy groceries"),
    TodoItem(title: "Call mom"),
  ];

  List<TodoItem> completedList = [
    TodoItem(title: "Finish homework", isCompleted: true),
  ];

  List<TodoItem> deletedList = []; // 삭제된 할일 리스트

  // 오른쪽 스와이프로 Todo -> Completed 이동
  void _completeTodo(TodoItem todo) {
    setState(() {
      todoList.remove(todo);
      todo.isCompleted = true;
      completedList.add(todo);
    });
  }

  // 오른쪽 스와이프로 Completed -> Deleted 이동
  void _deleteTodoFromCompleted(TodoItem todo) {
    setState(() {
      completedList.remove(todo);
      deletedList.add(todo);
    });
  }

  // 오른쪽 스와이프로 Deleted에서 영구 삭제
  void _deleteTodoForever(TodoItem todo) {
    setState(() {
      deletedList.remove(todo);
    });
  }

  // 왼쪽 스와이프로 Completed -> Todo 이동 (캔슬)
  void _cancelCompleted(TodoItem todo) {
    setState(() {
      completedList.remove(todo);
      todo.isCompleted = false;
      todoList.add(todo);
    });
  }

  // 왼쪽 스와이프로 Deleted -> Completed 복구
  void _restoreDeleted(TodoItem todo) {
    setState(() {
      deletedList.remove(todo);
      completedList.add(todo);
    });
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
            // Todo 그룹
            TodoList(
              title: "To-Do",
              todos: todoList,
              onRightSwipe: _completeTodo, // 오른쪽 스와이프 시 Completed로
            ),
            // Completed 그룹
            TodoList(
              title: "Completed",
              todos: completedList,
              onRightSwipe: _deleteTodoFromCompleted, // 오른쪽 스와이프 시 Deleted로
              onLeftSwipe: _cancelCompleted, // 왼쪽 스와이프 시 Todo로
            ),
            // Deleted 그룹
            TodoList(
              title: "Deleted",
              todos: deletedList,
              onRightSwipe: _deleteTodoForever, // 오른쪽 스와이프 시 영구 삭제
              onLeftSwipe: _restoreDeleted, // 왼쪽 스와이프 시 Completed로 복구
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
