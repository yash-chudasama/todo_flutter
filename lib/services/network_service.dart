import 'package:dio/dio.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/util/server_urls.dart';

class NetworkService {
  final Dio dio = Dio();

  Future<bool> addTodo(Todo model) async {
    final res = await dio.post(todosUrl, data: model.toJson());
    print(res.toString());
    return res.statusCode == 200;
  }

  Future<Todos> getTodos() async {
    final res = await dio.get(todosUrl);
    print(res.toString());
    return Todos.fromJson(res.data);
  }

  Future<bool> deleteTodo(String id) async {
    final res = await dio.delete("$todosUrl/$id");
    print(res.toString());
    return res.statusCode == 200;
  }

  Future<bool> updateTodo(String id, bool hasDone) async {
    final res = await dio.put("$todosUrl/$id", data: {'hasDone': hasDone});
    return res.statusCode == 200;
  }
}
