//Creating an abstract class responsible for getting the state of the application after processing by the business logic.
abstract class UserState {}

class UserEmptyState extends UserState {}

class UserLoadingState extends UserState {}

// loaded all tasks state
class UserLoadedTasksState extends UserState {
  List<dynamic> loadedTasks;
  UserLoadedTasksState({required this.loadedTasks});
}

// loaded work tasks state
class UserLoadedWorkTasksState extends UserState {
  List<dynamic> loadedWorkTasks;
  UserLoadedWorkTasksState({required this.loadedWorkTasks});
}

// loaded home tasks state
class UserLoadedHomeTasksState extends UserState {
  List<dynamic> loadedHomeTasks;
  UserLoadedHomeTasksState({required this.loadedHomeTasks});
}

class UserErrorState extends UserState {}
