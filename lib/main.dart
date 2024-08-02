import 'package:flutter/material.dart';
import 'package:minimal_habbit_tracker/database/habit_database.dart';
import 'package:minimal_habbit_tracker/pages/homepage.dart';
import 'package:minimal_habbit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize database

  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHome(),
      theme: Provider.of<ThemeProvider>(context).themedata,
    );
  }
}
