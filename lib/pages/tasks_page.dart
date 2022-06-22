import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wars_test_task/services/repository_tasks.dart';
import 'package:soft_wars_test_task/widgets/button_create_task.dart';

import '../bloc/block.dart';
import '../widgets/list_tasks.dart';
import '../widgets/menu_tasks.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

//This page is intended to display all tasks received from the server

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    //We initialize the repository from which we send requests to receive data from the server
    TasksRepository tasksRepository = TasksRepository();

    // Block initialization in the application
    return BlocProvider<UserBloc>(
        //Associating our block with the repository
        create: (context) => UserBloc(tasksRepository),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xffA9A9A9),
                  Color(0xff383838),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.08,
                ),
                //Task menu display
                const TasksMenu(),
                //Widget displays all tasks.
                const Expanded(child: TasksList()),
                const SizedBox(
                  height: 15,
                ),
                // Button responds to create new task.
                const ButtonCreateTask(),
                SizedBox(height: height * 0.03)
              ],
            ),
          ),
        ));
  }
}
