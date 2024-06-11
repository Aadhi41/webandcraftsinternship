import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/todo_provider.dart';
import 'screens/login_page.dart';
import 'screens/todo_list_screen.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/todos': (context) => TodoListScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
