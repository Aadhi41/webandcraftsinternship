import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo currentTodo;

  EditTodoDialog({required this.currentTodo});

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _taskController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.currentTodo.task);
    _selectedDate = widget.currentTodo.createdAt;
    _selectedTime = TimeOfDay(
      hour: widget.currentTodo.createdAt.hour,
      minute: widget.currentTodo.createdAt.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _taskController,
              decoration: InputDecoration(hintText: 'Enter your todo'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text("Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Select Date'}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            ListTile(
              title: Text("Time: ${_selectedTime != null ? _selectedTime?.format(context) : 'Select Time'}"),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
              final task = _taskController.text;
              final createdAt = DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
                _selectedTime!.hour,
                _selectedTime!.minute,
              );
              Navigator.of(context).pop(Todo(
                task: task,
                createdAt: createdAt,
              ));
            }
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
