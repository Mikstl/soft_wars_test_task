import 'dart:convert';

import '../models/task.dart';
import 'package:http/http.dart' as http;

class ServerApiProvider {
  // Getting all tasks from server
  Future<List<Task>> getTasks() async {
    //send get request from the server.
    var response =
        await http.get(Uri.parse('https://6btazh3lm3x5.softwars.com.ua/tasks'));
    if (response.statusCode == 200) {
      //decode request server
      Map<String, dynamic> userJson = json.decode(response.body);
      List userJsonData = userJson["data"];
      // Create list tasks using factory constructor on model class Task
      return userJsonData.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception("Not Tasks");
    }
  }

  // Update status task from the server
  void putTask(int? idTask, int? status) async {
    // send put request from the server
    await http.put(
      Uri.parse('https://6btazh3lm3x5.softwars.com.ua/tasks/$idTask'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'status': status,
      }),
    );
  }

  // Update values task from the server
  void putUpdateTask(Map<String, dynamic> body) async {
    List<dynamic> testTask = [body];
    //encode our map in json request
    var bytes = utf8.encode(json.encode(testTask));
    var response = await http.put(
      Uri.parse('https://6btazh3lm3x5.softwars.com.ua/tasks/'),
      body: bytes,
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to create album.');
    }
  }

  // Create new task on the server
  void createTask(Map<String, dynamic> body) async {
    List<dynamic> testTask = [body];
    //encode our map in json request
    var bytes = utf8.encode(json.encode(testTask));
    // send POST request from the server
    var response = await http.post(
      Uri.parse('https://6btazh3lm3x5.softwars.com.ua/tasks/'),
      body: bytes,
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to create album.');
    }
  }

  // Delete task on the server
  void deleteTask(int? idTask) async {
    await http.delete(
      Uri.parse('https://6btazh3lm3x5.softwars.com.ua/tasks/$idTask'),
    );
  }
}
