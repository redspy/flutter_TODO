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

  // Todo 리스트에서 순서를 바꾸는 함수
  void _reorderTodos(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final TodoItem item = todoList.removeAt(oldIndex);
      todoList.insert(newIndex, item);
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
            autofocus: true, // 입력창에 바로 커서가 가도록 설정
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

  // 휴지통 버튼을 눌렀을 때 그룹 전체 삭제
  void _deleteGroupItems(String group) {
    setState(() {
      if (group == "Completed") {
        completedList.clear(); // Completed 그룹의 모든 항목을 삭제
      } else if (group == "Deleted") {
        deletedList.clear(); // Deleted 그룹의 모든 항목을 삭제
      }
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: Icon(Icons.add),
      ),
    );
  }
}
