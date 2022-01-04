// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../models/todo.dart';
import '../util/server_urls.dart';

class NetworkService {
  final Dio dio = Dio();

  Future<bool> addTodo(Todo model) async {
    try {
      final res = await dio.post(todosUrl, data: model.toJson());
      return res.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<Todos> getTodos() async {
    try {
      final res = await dio.get(todosUrl);
      return Todos.fromJson(res.data);
    } catch (e) {
      print("Error: $e");
      return Todos();
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      final res = await dio.delete("$todosUrl/$id");
      return res.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<bool> updateTodo(String id, bool hasDone) async {
    try {
      final res = await dio.put("$todosUrl/$id", data: {'hasDone': hasDone});
      return res.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
