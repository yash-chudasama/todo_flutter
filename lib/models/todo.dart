import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todos {
  Todos({
    this.list = const [],
  });

  List<Todo> list;

  factory Todos.fromJson(Map<String, dynamic> json) => Todos(
        list: List<Todo>.from(json["list"].map((x) => Todo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class Todo {
  Todo({
    this.id = "",
    this.title = "",
    this.description = "",
    this.hasDone = false,
    this.dueDate,
  });

  String id;
  String title;
  String description;
  bool hasDone;
  DateTime? dueDate;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        hasDone: json["hasDone"],
        dueDate:
            json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "hasDone": hasDone,
        "dueDate": dueDate?.toIso8601String(),
      };
}
