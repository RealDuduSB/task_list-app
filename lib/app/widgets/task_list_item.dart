import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:task_list/app/models/todo.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({Key? key, required this.todo, required this.onDelete})
      : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          padding: EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                todo.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              onPressed: (context) {
                onDelete(todo);
              },
              backgroundColor: Color(0xFFFF0000),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Remover',
            ),
          ],
        ),
      ),
    );
  }
}
