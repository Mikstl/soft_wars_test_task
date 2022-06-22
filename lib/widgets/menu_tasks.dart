import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/block.dart';
import '../bloc/event_block.dart';

class TasksMenu extends StatefulWidget {
  const TasksMenu({Key? key}) : super(key: key);

  @override
  State<TasksMenu> createState() => TasksMenuState();
}

class TasksMenuState extends State<TasksMenu> {
  int _selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    //Getting the width and height of our application window
    var size = MediaQuery.of(context).size;
    var sizeContainer = size.width * 0.25;

    //Initialization of a variable responsible for storing application path settings and receiving data passed from another window
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    //The switch responsible for sending an event to receive a specific list of tasks
    switch (_selectedButton) {
      case 2:
        {
          userBloc.add(UserLoadHomeTasks());
        }
        break;
      case 1:
        {
          userBloc.add(UserLoadWorkTasks());
        }
        break;
      default:
        {
          userBloc.add(UserLoadTasks());
        }
        break;
    }

    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 70,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(Size(sizeContainer, 58)),
                      backgroundColor: (_selectedButton == 0
                          ? MaterialStateProperty.all(const Color(0xffFCF5AB))
                          : MaterialStateProperty.all(const Color(0xffF2FAFD))),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedButton = 0;
                      });
                    },
                    child: const Text(
                      "Усі",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(Size(sizeContainer, 58)),
                      backgroundColor: (_selectedButton == 1
                          ? MaterialStateProperty.all(const Color(0xffFCF5AB))
                          : MaterialStateProperty.all(const Color(0xffF2FAFD))),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedButton = 1;
                      });
                    },
                    child: const Text(
                      "Робочі",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(Size(sizeContainer, 58)),
                      backgroundColor: (_selectedButton == 2
                          ? MaterialStateProperty.all(const Color(0xffFCF5AB))
                          : MaterialStateProperty.all(const Color(0xffF2FAFD))),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedButton = 2;
                      });
                    },
                    child: const Text(
                      "Особисті",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ))),
          ],
        ));
  }
}
