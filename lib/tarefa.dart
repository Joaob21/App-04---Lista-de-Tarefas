import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_list/theme_controller.dart';
import 'package:task_list/todo.dart';
import 'my_app.dart';

class TaskTile extends StatelessWidget {
  ToDo todo;
  void Function(ToDo todo) deleteTask;
  TaskTile({required this.todo, required this.deleteTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteTask(todo);
              },
              backgroundColor: Colors.redAccent,
              icon: Icons.delete,
              label: 'Deletar',
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(80, 0, 150, 135),
                borderRadius: BorderRadius.circular(0),
              ),
              child: ListTile(
                title: Text(
                  'criado em ${DateFormat('dd/MM/yyyy - HH:mm').format(todo.date)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 121, 119, 119),
                  ),
                ),
                subtitle: Text(
                  todo.tarefa,
                  style: TextStyle(
                    fontSize: 20,
                    color: ThemeController.instance.isDarkTheme
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
