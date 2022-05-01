import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/todo.dart';

class HiveTodoRepository extends ChangeNotifier {
  List<Todo> _list = [];
  get list => _list;
  int? deletedIndex;
  Todo? deletedTodo;
  late LazyBox box;

  HiveTodoRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await readTodos();
  }

  _openBox() async {
    Hive.registerAdapter(TodoAdapter());
    box = await Hive.openLazyBox('todos_box');
  }

  readTodos() {
    box.keys.forEach((element) async {
      Todo todo = await box.get(element);
      if (!_list.any((element) => todo.date == element.date)) {
        _list.add(todo);

        notifyListeners();
      }
    });
  }

  saveTodos(Todo todos) {
    if (!_list.any((todo) => todo.date == todos.date)) {
      _list.add(todos);
      box.put(todos.date.toString(), todos);
      notifyListeners();
    }
  }

  deleteTodo(Todo todo, BuildContext context) {
    deletedTodo = todo;
    deletedIndex = _list.indexOf(todo);
    _list.remove(todo);
    box.delete(todo.date.toString());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Tarefa ${todo.tarefa} deletada."),
        action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              _list.insert(deletedIndex!, todo);
              box.clear();
              _list.forEach((element) async {
                await box.put(element.date.toString(), element);

                notifyListeners();
              });
            })));
    notifyListeners();
  }

  deleteAll(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Deseja deletar todas as tarefas?"),
            actions: [
              TextButton(
                  child: Text(
                    "Não",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text("Sim"),
                onPressed: () {
                  _list.clear();
                  box.clear();
                  Navigator.pop(context);
                  notifyListeners();
                },
              )
            ],
          );
        });
  }
}
