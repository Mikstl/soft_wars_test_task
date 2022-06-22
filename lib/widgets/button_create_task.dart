import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wars_test_task/bloc/block.dart';
import 'package:soft_wars_test_task/bloc/event_block.dart';

class ButtonCreateTask extends StatefulWidget {
  const ButtonCreateTask({Key? key}) : super(key: key);

  @override
  State<ButtonCreateTask> createState() => _ButtonCreateTaskState();
}

// This describes the button widget that performs the creation of a new task.

class _ButtonCreateTaskState extends State<ButtonCreateTask> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final widthButton = width * 0.17;
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return Container(
        margin: const EdgeInsets.only(right: 25),
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            _returnDataFromSecondScreen(context, userBloc);
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              )),
              minimumSize:
                  MaterialStateProperty.all(Size(widthButton, widthButton)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xffFFD600))),
          child: const Text(
            "+",
            style: TextStyle(
                fontSize: 40,
                color: Color(0xff383838),
                fontWeight: FontWeight.w500),
          ),
        ));
  }

  //Сreate an asynchronous function waiting for the user to return after creating a new task,
  //and update the state of our application to receive the created task from the server
  void _returnDataFromSecondScreen(BuildContext context, var userBloc) async {
    await Navigator.pushNamed(
      context,
      '/second',
    );
    setState(() {
      userBloc.add(UserLoadTasks());
    });
  }
}
