import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/edit_todo_dialog.dart';
import '../screens/login_page.dart'; // Ensure this import points to the correct location of LoginPage

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('isLoggedIn');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return ListTile(
                title: Text(todo.task),
                subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(todo.createdAt)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editTodoItem(context, todoProvider, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodoItem(context, todoProvider, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoItem(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem(BuildContext context) async {
    final newTodo = await showDialog<Todo>(
      context: context,
      builder: (context) => AddTodoDialog(),
    );
    if (newTodo != null) {
      Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);
    }
  }

  void _editTodoItem(BuildContext context, TodoProvider todoProvider, int index) async {
    final currentTodo = todoProvider.todos[index];
    final updatedTodo = await showDialog<Todo>(
      context: context,
      builder: (context) => EditTodoDialog(currentTodo: currentTodo),
    );
    if (updatedTodo != null) {
      todoProvider.editTodo(index, updatedTodo);
    }
  }

  void _deleteTodoItem(BuildContext context, TodoProvider todoProvider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Todo'),
        content: Text('Are you sure you want to delete this todo?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoProvider.deleteTodo(index);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
