import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wars_test_task/models/task.dart';

import '../bloc/block.dart';
import '../bloc/event_block.dart';
import '../bloc/state_block.dart';

class TasksList extends StatefulWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

//Widget used to display tasks from the server
class _TasksListState extends State<TasksList> {
  //A function that uses color setting depending on the type of task
  Color setbackgorundColor(int type, int status) {
    if (type == 1 && status == 2) {
      return const Color(0xffFBEFB4);
    } else if (type == 1 && status == 1) {
      return const Color(0xffFF8989);
    } else if (type == 2 && status == 2) {
      return const Color(0xffFBEFB4);
    } else {
      return const Color(0xffDBDBDB);
    }
  }

  //A function that sends task state changes to the server
  void _changeSwitch({var userBloc, state, required int index}) {
    userBloc.add(UserPutTasks(
        idTask: state.loadedTasks[index].id,
        status: state.loadedTasks[index].status == 1 ? 2 : 1));
    setState(() {
      userBloc.add(UserLoadTasks());
    });
  }

  @override
  Widget build(BuildContext context) {
    //Initializing our block to send events from this widget to our business logic
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    //Getting the width and height of our application window
    final size = MediaQuery.of(context).size;
    final width = size.width;

    //A function that passes the value of the task fields received from the server for further editing
    void _returnDataFromSecondScreen(
        {required BuildContext context,
        var userBloc,
        Task? sendDateToNextRoute,
        required int typeTask}) async {
      await Navigator.pushNamed(context, '/change',
          arguments: sendDateToNextRoute);
      //Conditions that determine from which list of tasks editing was selected
      switch (typeTask) {
        case 1:
          {
            setState(() {
              userBloc.add(UserLoadTasks());
            });
          }
          break;
        case 2:
          {
            setState(() {
              userBloc.add(UserLoadWorkTasks());
            });
          }
          break;
        case 3:
          {
            setState(() {
              userBloc.add(UserLoadHomeTasks());
            });
          }
          break;
      }
    }

    //Initialization of the Bloc widget that converts the received state from the business logic to the UI
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return Container(
            margin: const EdgeInsets.only(bottom: 35, left: 20, right: 20),
            child: const Text('Please wait...',
                style: TextStyle(
                    color: Color(0xff111111),
                    fontSize: 30,
                    fontWeight: FontWeight.w400)),
          );
        }

        if (state is UserLoadedTasksState) {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.loadedTasks.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      //Sending task data to the task editing page
                      Task sendDateToNextRoute = Task(
                        id: state.loadedTasks[index].id,
                        status: state.loadedTasks[index].status,
                        name: state.loadedTasks[index].name,
                        type: state.loadedTasks[index].type,
                        description: state.loadedTasks[index].description,
                        finishDate: state.loadedTasks[index].finishDate,
                        urgent: state.loadedTasks[index].urgent,
                        syncTime: state.loadedTasks[index].syncTime,
                        file: state.loadedTasks[index].file,
                      );
                      int typeTask = 1;
                      _returnDataFromSecondScreen(
                          typeTask: typeTask,
                          context: context,
                          userBloc: userBloc,
                          sendDateToNextRoute: sendDateToNextRoute);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                      padding: const EdgeInsets.only(
                          bottom: 13, left: 16, right: 20, top: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: state.loadedTasks[index].type == 1
                            ? const Color(0xffFF8989)
                            : const Color(0xffDBDBDB),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: width * 0.05,
                            child: Icon(
                              state.loadedTasks[index].type == 1
                                  ? Icons.work_outline
                                  : Icons.home_outlined,
                              size: width * 0.070,
                              color: const Color(0xff111111),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            width: width * 0.50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.loadedTasks[index].name,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(state.loadedTasks[index].finishDate,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _changeSwitch(
                                  userBloc: userBloc,
                                  state: state,
                                  index: index);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff383838),
                                  width: 1,
                                ),
                                color: setbackgorundColor(
                                    state.loadedTasks[index].type,
                                    state.loadedTasks[index].status),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: (state.loadedTasks[index].status == 2
                                  ? Icon(
                                      Icons.done,
                                      size: width * 0.08,
                                      color: const Color(0xff383838),
                                    )
                                  : null),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        }

        if (state is UserLoadedWorkTasksState) {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.loadedWorkTasks.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      //Sending task data to the task editing page
                      Task sendDateToNextRoute = Task(
                        id: state.loadedWorkTasks[index].id,
                        status: state.loadedWorkTasks[index].status,
                        name: state.loadedWorkTasks[index].name,
                        type: state.loadedWorkTasks[index].type,
                        description: state.loadedWorkTasks[index].description,
                        finishDate: state.loadedWorkTasks[index].finishDate,
                        urgent: state.loadedWorkTasks[index].urgent,
                        syncTime: state.loadedWorkTasks[index].syncTime,
                        file: state.loadedWorkTasks[index].file,
                      );
                      int typeTask = 2;
                      _returnDataFromSecondScreen(
                          typeTask: typeTask,
                          context: context,
                          userBloc: userBloc,
                          sendDateToNextRoute: sendDateToNextRoute);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                      padding: const EdgeInsets.only(
                          bottom: 13, left: 16, right: 20, top: 14),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xffFF8989),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: width * 0.05,
                            child: Icon(
                              state.loadedWorkTasks[index].type == 1
                                  ? Icons.work_outline
                                  : Icons.home_outlined,
                              size: width * 0.070,
                              color: const Color(0xff111111),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            width: width * 0.50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.loadedWorkTasks[index].name,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(state.loadedWorkTasks[index].finishDate,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              userBloc.add(UserPutTasks(
                                  idTask: state.loadedWorkTasks[index].id,
                                  status:
                                      state.loadedWorkTasks[index].status == 1
                                          ? 2
                                          : 1));
                              setState(() {
                                userBloc.add(UserLoadWorkTasks());
                              });
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff383838),
                                  width: 1,
                                ),
                                color: setbackgorundColor(
                                    state.loadedWorkTasks[index].type,
                                    state.loadedWorkTasks[index].status),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: (state.loadedWorkTasks[index].status == 2
                                  ? Icon(
                                      Icons.done,
                                      size: width * 0.08,
                                      color: const Color(0xff383838),
                                    )
                                  : null),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        }

        if (state is UserLoadedHomeTasksState) {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.loadedHomeTasks.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      //Sending task data to the task editing page
                      Task sendDateToNextRoute = Task(
                        id: state.loadedHomeTasks[index].id,
                        status: state.loadedHomeTasks[index].status,
                        name: state.loadedHomeTasks[index].name,
                        type: state.loadedHomeTasks[index].type,
                        description: state.loadedHomeTasks[index].description,
                        finishDate: state.loadedHomeTasks[index].finishDate,
                        urgent: state.loadedHomeTasks[index].urgent,
                        syncTime: state.loadedHomeTasks[index].syncTime,
                        file: state.loadedHomeTasks[index].file,
                      );
                      int typeTask = 3;
                      _returnDataFromSecondScreen(
                          typeTask: typeTask,
                          context: context,
                          userBloc: userBloc,
                          sendDateToNextRoute: sendDateToNextRoute);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                      padding: const EdgeInsets.only(
                          bottom: 13, left: 16, right: 20, top: 14),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xffDBDBDB),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: width * 0.05,
                            child: Icon(
                              state.loadedHomeTasks[index].type == 1
                                  ? Icons.work_outline
                                  : Icons.home_outlined,
                              size: width * 0.070,
                              color: const Color(0xff111111),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            width: width * 0.50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.loadedHomeTasks[index].name,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(state.loadedHomeTasks[index].finishDate,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              userBloc.add(UserPutTasks(
                                  idTask: state.loadedHomeTasks[index].id,
                                  status:
                                      state.loadedHomeTasks[index].status == 1
                                          ? 2
                                          : 1));
                              setState(() {
                                userBloc.add(UserLoadHomeTasks());
                              });
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff383838),
                                  width: 1,
                                ),
                                color: setbackgorundColor(
                                    state.loadedHomeTasks[index].type,
                                    state.loadedHomeTasks[index].status),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: (state.loadedHomeTasks[index].status == 2
                                  ? Icon(
                                      Icons.done,
                                      size: width * 0.08,
                                      color: const Color(0xff383838),
                                    )
                                  : null),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: null,
        );
      },
    );
  }
}
