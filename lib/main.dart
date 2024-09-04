// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/todo_app.dart';

void main() => runApp(MaterialApp(
      home: TodoApp(),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    ));
