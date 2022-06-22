import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wars_test_task/bloc/event_block.dart';
import 'package:soft_wars_test_task/bloc/state_block.dart';
import 'package:soft_wars_test_task/models/task.dart';
import 'package:soft_wars_test_task/services/repository_tasks.dart';

//Class for working with business logic.
class UserBloc extends Bloc<UserEvent, UserState> {
  //Initializes a class that works with the server API
  TasksRepository taskRepository;

  //Determine the state of the business logic during initialization
  UserBloc(this.taskRepository) : super(UserEmptyState()) {
    //Get all tasks
    on<UserLoadTasks>((event, emit) async {
      // emit(UserLoadingState());
      try {
        //Getting a list of our tasks from the server
        final List<Task> loadedTasksList = await taskRepository.getAllTasks();
        //Passing the state to the application with a ready list of tasks
        emit(UserLoadedTasksState(loadedTasks: loadedTasksList));
      } catch (_) {
        //If an error returns
        emit(UserErrorState());
      }
    });

    //Get work tasks
    on<UserLoadWorkTasks>((event, emit) async {
      // emit(UserLoadingState());
      try {
        //getting a list of work tasks from the server
        final List<Task> loadedWorkTasksList =
            await taskRepository.getWorkTasks();
        //Passing the state to the application with a ready list of tasks
        emit(UserLoadedWorkTasksState(loadedWorkTasks: loadedWorkTasksList));
      } catch (_) {
        emit(UserErrorState());
      }
    });

    //Get home tasks
    on<UserLoadHomeTasks>((event, emit) async {
      try {
        //getting a list of home tasks from the server
        final List<Task> loadedHomeTasksList =
            await taskRepository.getHomeTasks();
        //Passing the state to the application with a ready list of tasks
        emit(UserLoadedHomeTasksState(loadedHomeTasks: loadedHomeTasksList));
      } catch (_) {
        emit(UserErrorState());
      }
    });

    //Update task status
    on<UserPutTasks>((event, emit) async {
      try {
        //Transferring the task number and status
        taskRepository.putTask(event.idTask, event.status);
      } catch (_) {
        emit(UserErrorState());
      }
    });

    //Create mew task
    on<UserCreateTask>((event, emit) async {
      try {
        //Passing all the arguments needed to create a new task
        taskRepository.createTask(
          idTask: event.taskId,
          type: event.type,
          status: event.status,
          name: event.name,
          selectedDate: event.selectedDate,
          urgent: event.urgent,
          image: event.image,
          description: event.description,
        );
      } catch (_) {
        emit(UserErrorState());
      }
    });
    //Task update
    on<UserPutUpdateTask>((event, emit) async {
      try {
        taskRepository.createTask(
          idTask: event.taskId,
          type: event.type,
          status: event.status,
          name: event.name,
          selectedDate: event.selectedDate,
          urgent: event.urgent,
          image: event.image,
          description: event.description,
        );
      } catch (_) {
        emit(UserErrorState());
      }
    });
    //Task delete
    on<UserDeleteTask>((event, emit) async {
      try {
        taskRepository.deleteTask(idTask: event.taskId);
      } catch (_) {
        emit(UserErrorState());
      }
    });
  }
}
