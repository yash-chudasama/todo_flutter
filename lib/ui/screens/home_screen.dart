import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/network_service.dart';
import 'package:todo_app/ui/widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkService _networkService = NetworkService();

  Key key = UniqueKey();
  String title = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: FutureBuilder<Todos>(
        future: _networkService.getTodos(),
        builder: (context, snapshot) {
          print(snapshot.connectionState.toString());
          return snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: (snapshot.data?.list ?? [])
                        .map<ToDoTile>(
                          (e) => ToDoTile(
                            title: e.title,
                            description: e.description,
                            hasDone: e.hasDone,
                            onClick: () async {
                              if (await _networkService.updateTodo(
                                  e.id, !e.hasDone))
                                setState(() => {e.hasDone = !e.hasDone});
                            },
                            onDelete: () async {
                              await _networkService.deleteTodo(e.id);
                              setState(() {
                                key = UniqueKey();
                              });
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
                decoration: InputDecoration(labelText: "Title")),
            TextField(
                onChanged: (value) => description = value,
                decoration: InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Add"),
            onPressed: () async {
              bool done = await _networkService
                  .addTodo(Todo(title: title, description: description));
              key = UniqueKey();
              if (done) {
                Navigator.of(context).pop();
              } else {
                Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to add todo")));
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
}
