import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/my_app.dart';
import 'package:task_list/repositories/hive_configs.dart';
import 'package:task_list/repositories/todo_hive_rep.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfigs.start();
  runApp(ChangeNotifierProvider(
    create: (context) => HiveTodoRepository(),
    builder: (context, _) => MyApp(),
  ));
}
