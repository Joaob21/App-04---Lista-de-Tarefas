class ToDo {
  ToDo({required this.tarefa, required this.date});
  String tarefa;
  DateTime date;

  ToDo.fromJson(Map<String, dynamic> json)
      : tarefa = json['title'],
        date = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() {
    return {
      'title': tarefa,
      'dateTime': date.toIso8601String(),
    };
  }
}
