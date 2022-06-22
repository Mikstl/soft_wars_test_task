//Creating an abstract class from which all events transmitted to the business logic are inherited (block)
abstract class UserEvent {}

// event when upload all tasks
class UserLoadTasks extends UserEvent {}

// event when upload work tasks
class UserLoadWorkTasks extends UserEvent {}

// event when upload home tasks
class UserLoadHomeTasks extends UserEvent {}

// event delete task
class UserDeleteTask extends UserEvent {
  int? taskId;
  UserDeleteTask({this.taskId});
}

// event when need to set task status
class UserPutTasks extends UserEvent {
  int? idTask;
  int? status;
  UserPutTasks({this.idTask, this.status});
}

// event when need update task
class UserPutUpdateTask extends UserEvent {
  String? taskId;
  int? status;
  int? urgent;
  String? name;
  String? description;
  String? image;
  String? selectedDate;
  int? type;
  UserPutUpdateTask(
      {this.taskId,
      this.status,
      this.urgent,
      this.name,
      this.description,
      this.image,
      this.selectedDate,
      this.type});
}

// event creating task
class UserCreateTask extends UserEvent {
  String? taskId;
  int? status;
  int? urgent;
  String? name;
  String? description;
  String? image;
  String? selectedDate;
  int? type;
  UserCreateTask(
      {this.taskId,
      this.status,
      this.urgent,
      this.name,
      this.description,
      this.image,
      this.selectedDate,
      this.type});
}
