import 'package:flutter/material.dart';
import 'package:news_application/core/services/hive_database_service.dart';
import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabaseService().setUpHive();
  await IsarDatabaseService().init();
  runApp(MyApp());
}
