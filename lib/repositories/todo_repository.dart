import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../todo.dart';

class TodoRepository {
  late SharedPreferences sharedPreferences;
  String todoListKey = 'todo_list';

  Future<List<ToDo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => ToDo.fromJson(e)).toList();
  }

  void saveTodoList(List<ToDo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
