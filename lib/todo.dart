import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo {
  Todo({required this.tarefa, required this.date});
  @HiveField(0)
  String tarefa;

  @HiveField(1)
  String date;
}
