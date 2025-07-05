import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMorePages = false;
  int _totalTasks = 0;
  
  // Filter properties
  String? _statusFilter;
  String? _priorityFilter;
  String? _searchQuery;

  // Getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMorePages => _hasMorePages;
  int get totalTasks => _totalTasks;
  String? get statusFilter => _statusFilter;
  String? get priorityFilter => _priorityFilter;
  String? get searchQuery => _searchQuery;

  // Load tasks with optional filters
  Future<void> loadTasks({
    String? status,
    String? priority,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _tasks.clear();
    }

    _isLoading = true;
    _error = null;
    _statusFilter = status;
    _priorityFilter = priority;
    _searchQuery = search;
    notifyListeners();

    try {
      final response = await ApiService.getTasks(
        status: status,
        priority: priority,
        search: search,
        page: _currentPage,
      );

      if (refresh) {
        _tasks = response.data;
      } else {
        _tasks.addAll(response.data);
      }

      _currentPage = response.currentPage;
      _hasMorePages = response.hasMorePages;
      _totalTasks = response.total;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load more tasks for pagination
  Future<void> loadMoreTasks() async {
    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getTasks(
        status: _statusFilter,
        priority: _priorityFilter,
        search: _searchQuery,
        page: _currentPage + 1,
      );

      _tasks.addAll(response.data);
      _currentPage = response.currentPage;
      _hasMorePages = response.hasMorePages;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create a new task
  Future<void> createTask(Task task) async {
    try {
      final newTask = await ApiService.createTask(task);
      _tasks.insert(0, newTask);
      _totalTasks++;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update an existing task
  Future<void> updateTask(int id, Task task) async {
    try {
      final updatedTask = await ApiService.updateTask(id, task);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await ApiService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      _totalTasks--;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get a single task
  Future<Task?> getTask(int id) async {
    try {
      return await ApiService.getTask(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh tasks
  Future<void> refreshTasks() async {
    await loadTasks(
      status: _statusFilter,
      priority: _priorityFilter,
      search: _searchQuery,
      refresh: true,
    );
  }

  // Clear filters
  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _searchQuery = null;
    refreshTasks();
  }

  // Apply filters
  void applyFilters({
    String? status,
    String? priority,
    String? search,
  }) {
    loadTasks(
      status: status,
      priority: priority,
      search: search,
      refresh: true,
    );
  }

  // Get tasks by status for quick access
  List<Task> getTasksByStatus(String status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  // Get overdue tasks
  List<Task> get overdueTasks {
    return _tasks.where((task) => task.isOverdue).toList();
  }

  // Get tasks count by status
  Map<String, int> get taskCountByStatus {
    final Map<String, int> counts = {
      'pending': 0,
      'in_progress': 0,
      'completed': 0,
    };

    for (final task in _tasks) {
      counts[task.status] = (counts[task.status] ?? 0) + 1;
    }

    return counts;
  }
}
