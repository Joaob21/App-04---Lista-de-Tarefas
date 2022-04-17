// ignore_for_file: , prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:task_list/repositories/todo_repository.dart';
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
          child: ToDoListPage(),
        ),
      ),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  @override
  State<ToDoListPage> createState() => ToDoListPageState();
}

class ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController taskController = TextEditingController();

  List<ToDo> tarefas = [];
  List<ToDo> allDeleted = [];
  late ToDo deleted;
  late String tarefa;
  final TodoRepository todoRepository = TodoRepository();
  late int deletedIndex;
  bool fieldIsEmpty = false;
  String errorMessage = 'Erro - Campo vazio';

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          if (tarefas.length < 20) {
                            setTarefa();
                          }
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
                              tarefas.isNotEmpty ? null : 'Ex: Estudar...',
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
                        onPressed: tarefas.length < 20 ? setTarefa : null,
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) => TaskTile(
                    todo: tarefas[index],
                    deleteTask: deleteTask,
                  ),
                  shrinkWrap: true,
                ),
              ),
              SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Você possui ${tarefas.length} tarefas pendentes.",
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
                      onPressed: deleteAll,
                      child: Text("Limpar tudo"),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(25, 25),
                      ),
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

  void setTarefa() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tarefa = taskController.text;
        tarefas.add(ToDo(
          tarefa: tarefa,
          date: DateTime.now(),
        ));
        taskController.clear();
      });
      todoRepository.saveTodoList(tarefas);
    } else if (!fieldIsEmpty) {
      setState(() {
        fieldIsEmpty = !fieldIsEmpty;
      });
    }
  }

  void deleteTask(ToDo tarefa) {
    deleted = tarefa;
    deletedIndex = tarefas.indexOf(tarefa);
    setState(() {
      tarefas.remove(tarefa);
    });
    todoRepository.saveTodoList(tarefas);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('${tarefa.tarefa} foi removida',
            style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              tarefas.insert(deletedIndex, deleted);
            });
            todoRepository.saveTodoList(tarefas);
          },
        ),
      ),
    );
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tem certeza?"),
        content: Text("Deseja deletar todas as tarefas?"),
        actions: [
          TextButton(
            child: Text(
              "Não",
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Sim',
              style: TextStyle(
                color: Colors.teal,
              ),
            ),
            onPressed: () {
              setState(() {
                tarefas.clear();
              });
              Navigator.of(context).pop();
              todoRepository.saveTodoList(tarefas);
            },
          )
        ],
      ),
    );
  }
}
