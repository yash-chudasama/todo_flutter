// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../models/todo.dart';
import '../../services/network_service.dart';
import '../widgets/todo_tile.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const HomeScreen({Key? key, @required this.onThemeChanged}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkService _networkService = NetworkService();

  Key key = UniqueKey();
  String title = "";
  String description = "";
  DateTime dateTime = DateTime.now();
  List<Todo> dataList = [];
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
            onPressed: () {
              updateScreen();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onThemeChanged?.call(
                isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Todos>(
        future: _networkService.getTodos(),
        builder: (context, snapshot) {
          dataList = snapshot.data?.list ?? [];
          return snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: dataList
                        .map<ToDoTile>(
                          (e) => ToDoTile(
                            title: e.title,
                            description: e.description,
                            hasDone: e.hasDone,
                            date: e.dueDate,
                            onClick: () async {
                              if (await _networkService.updateTodo(
                                  e.id, !e.hasDone)) {
                                setState(() {
                                  e.hasDone = !e.hasDone;
                                });
                              }
                            },
                            onDelete: () async {
                              await _networkService.deleteTodo(e.id);
                              updateScreen();
                            },
                          ),
                        )
                        .toList(),
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddBtnClicked,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> onAddBtnClicked() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Todo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => title = value,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            TextField(
              onChanged: (value) => description = value,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            TextButton(
              onPressed: () async {
                dateTime = await DatePicker.showDatePicker(context,
                        minTime: DateTime.now(),
                        currentTime: DateTime.now(),
                        locale: LocaleType.en) ??
                    DateTime.now();
              },
              child: const Text("Due Date"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Add"),
            onPressed: () async {
              if (title.isNotEmpty &&
                  description.isNotEmpty &&
                  dateTime != null) {
                bool done = await _networkService.addTodo(Todo(
                    title: title, description: description, dueDate: dateTime));
                print("Done: $done");
                if (done) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to add todo")));
                }
                updateScreen();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please fill all the fields")));
              }
            },
          ),
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateScreen() async {
    List<Todo> list = (await _networkService.getTodos()).list;
    print("UpdateScreen()");
    setState(() {
      dataList = list;
      key = UniqueKey();
    });
  }
}
