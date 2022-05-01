// ignore_for_file: , prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/repositories/todo_hive_rep.dart';
import 'package:task_list/tarefa.dart';
import 'package:task_list/theme_controller.dart';
import 'package:task_list/todo.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, widget) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: ThemeController.instance.isDarkTheme
              ? Brightness.dark
              : Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        home: ScaffoldMessenger(
          child: TodoListPage(),
        ),
      ),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  State<TodoListPage> createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();

  List<Todo> tarefas = [];
  List<Todo> allDeleted = [];
  late Todo deleted;
  late String tarefa;
  late int deletedIndex;
  bool fieldIsEmpty = false;
  String errorMessage = 'Erro - Campo vazio';
  late var rep;

  @override
  Widget build(BuildContext context) {
    rep = Provider.of<HiveTodoRepository>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
              value: ThemeController.instance.isDarkTheme,
              onChanged: (value) {
                ThemeController.instance.changeTheme();
              })
        ],
        title: Row(
          children: [
            Icon(
              Icons.task_outlined,
              size: 20,
              color: Color.fromARGB(255, 171, 230, 224),
            ),
            Text(
              "Lista de Tarefas",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onSubmitted: (a) {
                          Todo todo = Todo(
                              tarefa: taskController.text,
                              date: DateTime.now().toString());
                          print(todo);
                          print(rep.list);
                          rep.saveTodos(todo);
                          taskController.clear();
                        },
                        controller: taskController,
                        onChanged: (task) {
                          if (fieldIsEmpty) {
                            setState(() {
                              fieldIsEmpty = !fieldIsEmpty;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          errorText: fieldIsEmpty ? errorMessage : null,
                          border: OutlineInputBorder(),
                          labelText: 'Nova tarefa',
                          hintText:
                              rep.list.isNotEmpty ? null : 'Ex: Estudar...',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            double.infinity,
                            59,
                          ),
                        ),
                        onPressed: () {
                          if (taskController.text.isNotEmpty) {
                            var todo = Todo(
                                tarefa: taskController.text,
                                date: DateTime.now().toString());
                            rep.saveTodos(todo);
                            taskController.clear();
                          } else {
                            setState(() {
                              fieldIsEmpty = true;
                            });
                          }
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<HiveTodoRepository>(builder: (_, rep, __) {
                return Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: rep.list.length,
                    itemBuilder: (context, index) => TaskTile(
                      todo: rep.list[index],
                      deleteTask: (todo) {
                        rep.deleteTodo(rep.list[index], context);
                      },
                    ),
                    shrinkWrap: true,
                  ),
                );
              }),
              SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Você possui ${rep.list.length} tarefas pendentes.",
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeController.instance.isDarkTheme
                            ? (tarefas.length < 20
                                ? Colors.white70
                                : Colors.red)
                            : (tarefas.length < 20
                                ? Colors.black87
                                : Colors.red),
                      ),
                    ),
                    flex: 22,
                  ),
                  Expanded(
                    flex: 11,
                    child: ElevatedButton(
                      onPressed: () {
                        rep.list.isNotEmpty ? rep.deleteAll(context) : null;
                      },
                      child: Text("Limpar tudo"),
                      style: ElevatedButton.styleFrom(fixedSize: Size(25, 25)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
