//description of the model of our task in the application

class Task {
  int? id;
  int? status;
  String? name;
  int? type;
  String? description;
  String? finishDate;
  int? urgent;
  String? syncTime;
  String? file;

  Task(
      {this.id,
      this.status,
      this.name,
      this.type,
      this.description,
      this.finishDate,
      this.urgent,
      this.syncTime,
      this.file});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json['taskId']),
      status: int.parse(json["status"]),
      name: json["name"],
      type: int.parse(json["type"]),
      description: json['description'],
      finishDate: json['finishDate'],
      urgent: int.parse(json['urgent']),
      syncTime: json['syncTime'],
      file: json['file'],
    );
  }
}
