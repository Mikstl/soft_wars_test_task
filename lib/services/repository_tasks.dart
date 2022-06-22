import '../models/task.dart';
import 'package:soft_wars_test_task/services/server_api_provider.dart';

//The storage is used to receive the response from the server and store them for sending to the UI

class TasksRepository {
  //Initialize the class responsible for the operation of the API
  final ServerApiProvider _provider = ServerApiProvider();

  // Get list All Tasks for the server
  Future<List<Task>> getAllTasks() {
    return _provider.getTasks();
  }

  // Get list Home Tasks for the server
  Future<List<Task>> getHomeTasks() async {
    final List<Task> loadedTasksList = await _provider.getTasks();
    List<Task> loadedHomeTasksList = [];
    for (var element in loadedTasksList) {
      if (element.type == 2) {
        loadedHomeTasksList.add(element);
      } else {
        continue;
      }
    }
    return loadedHomeTasksList;
  }

  // Get list Work Tasks for the server
  Future<List<Task>> getWorkTasks() async {
    final List<Task> loadedTasksList = await _provider.getTasks();
    List<Task> loadedWorkTasksList = [];
    for (var element in loadedTasksList) {
      if (element.type == 1) {
        loadedWorkTasksList.add(element);
      } else {
        continue;
      }
    }
    return loadedWorkTasksList;
  }

  // Send to update status task for the server
  void putTask(int? idTask, int? status) {
    return _provider.putTask(idTask, status);
  }

  //Create new task and upload on the server
  void createTask(
      {String? idTask,
      int? type,
      int? status,
      String? name,
      String? selectedDate,
      int? urgent,
      String? description,
      String? image}) {
    Map<String, dynamic> body = {
      "taskId": idTask,
      "status": status,
      "name": name,
      "type": type,
      "finishDate": selectedDate,
      "urgent": urgent,
    };

    // if description task not empty or null - add to the body for the upload on the server
    if (description != null) {
      body["description"] = description;
    }
    //if image task not empty or null - add to the body for the upload on the server
    if (image != null) {
      body["file"] = image;
    }
    return _provider.createTask(body);
  }

  //send idTask on the server for delete task from the server
  void deleteTask({int? idTask}) {
    return _provider.deleteTask(idTask);
  }
}
