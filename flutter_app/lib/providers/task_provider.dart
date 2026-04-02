import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_api_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskApiService _apiService = TaskApiService();

  List<Task> _tasks = [];
  String _searchQuery = '';
  String _statusFilter = 'All';
  bool _isFetching = false;
  bool _isSaving = false;
  String? _error;

  List<Task> get tasks => _tasks;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  bool get isFetching => _isFetching;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> loadTasks() async {
    _isFetching = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _apiService.fetchTasks(
        search: _searchQuery.trim(),
        // ✅ FIX: convert "All" → null
        status: _statusFilter == 'All' ? null : _statusFilter,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  void updateSearch(String value) {
    _searchQuery = value;
    loadTasks();
  }

  void updateStatusFilter(String value) {
    _statusFilter = value;
    loadTasks();
  }

  Future<bool> createTask(Task task) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.createTask(task);
      await loadTasks();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateTask(int id, Task task) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.updateTask(id, task);
      await loadTasks();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiService.deleteTask(id);
      await loadTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}