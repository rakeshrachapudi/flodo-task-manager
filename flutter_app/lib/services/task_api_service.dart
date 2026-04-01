import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/task.dart';

class TaskApiService {
  final String _baseUrl = AppConstants.baseUrl;

  Future<List<Task>> fetchTasks({String search = '', String status = 'All'}) async {
    final uri = Uri.parse(
      '$_baseUrl/tasks?search=${Uri.encodeComponent(search)}&status=${Uri.encodeComponent(status)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_extractError(response.body));
    }
  }

  Future<Task> updateTask(int id, Task task) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/tasks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_extractError(response.body));
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/tasks/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  String _extractError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded['errors'] != null) {
        return decoded['errors'].toString();
      }
      return decoded['message'] ?? 'Unknown error';
    } catch (_) {
      return 'Something went wrong';
    }
  }
}