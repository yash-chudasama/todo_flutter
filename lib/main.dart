import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/home_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ToDo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        color: Colors.white,
        home: const HomeScreen());
  }
}
