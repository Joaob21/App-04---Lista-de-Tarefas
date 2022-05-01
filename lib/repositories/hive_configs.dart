import 'package:hive_flutter/hive_flutter.dart';

class HiveConfigs {
  static start() async {
    await Hive.initFlutter();
  }
}
