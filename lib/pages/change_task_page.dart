import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wars_test_task/bloc/block.dart';

import '../services/repository_tasks.dart';
import '../widgets/change_form_task.dart';

class ChangeTaskPage extends StatefulWidget {
  const ChangeTaskPage({Key? key}) : super(key: key);

  @override
  State<ChangeTaskPage> createState() => _ChangeTaskPageState();
}
//This page is for editing an existing task

class _ChangeTaskPageState extends State<ChangeTaskPage> {
  @override
  Widget build(BuildContext context) {
    //We initialize the repository from which we send requests to receive data from the server
    TasksRepository tasksRepository = TasksRepository();
    // Block initialization in the application
    return BlocProvider<UserBloc>(
        //Associating our block with the repository
        create: (context) => UserBloc(tasksRepository),
        child: const Scaffold(
          resizeToAvoidBottomInset: false,
          body: ChangeTaskForm(),
        ));
  }
}
