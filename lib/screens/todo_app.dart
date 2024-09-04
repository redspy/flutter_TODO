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

  List<TodoItem> deletedList = []; // 삭제된 할일을 저장하는 리스트

  // 할일 완료 상태를 변경하는 함수
  void _toggleCompletion(TodoItem todo) {
    setState(() {
      if (completedList.contains(todo)) {
        // 완료된 할일이 스와이프되면 삭제 그룹으로 이동
        completedList.remove(todo);
        deletedList.add(todo);
      } else if (todo.isCompleted) {
        // 완료 상태에서 미완료로 변경
        todo.isCompleted = false;
        completedList.remove(todo);
        todoList.add(todo);
      } else {
        // 할일을 완료로 변경
        todo.isCompleted = true;
        todoList.remove(todo);
        completedList.add(todo);
      }
    });
  }

  // Deleted 그룹에서 할일을 영구적으로 삭제하는 함수
  void _deleteTodoForever(TodoItem todo) {
    setState(() {
      deletedList.remove(todo);
    });
  }

  // 할일 추가 함수 (다이얼로그 사용)
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
            TodoList(
              title: "To-Do",
              todos: todoList,
              onToggleCompletion: _toggleCompletion,
            ),
            TodoList(
              title: "Completed",
              todos: completedList,
              onToggleCompletion: _toggleCompletion,
            ),
            TodoList(
              title: "Deleted", // 삭제된 항목을 위한 리스트
              todos: deletedList,
              onToggleCompletion:
                  _deleteTodoForever, // 삭제된 항목은 다시 스와이프 시 완전히 삭제
              isDeleted: true, // 흐리게 표시하기 위해 전달
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
