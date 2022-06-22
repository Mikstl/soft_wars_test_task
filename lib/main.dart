import 'package:flutter/material.dart';
import 'package:soft_wars_test_task/pages/change_task_page.dart';
import 'package:soft_wars_test_task/pages/login_page.dart';
import 'package:soft_wars_test_task/pages/task_page.dart';
import 'package:soft_wars_test_task/pages/tasks_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      routes: {
        '/first': (context) => const TasksPage(),
        '/second': (context) => const TaskPage(),
        '/change': (context) => const ChangeTaskPage(),
      },
    );
  }
}
