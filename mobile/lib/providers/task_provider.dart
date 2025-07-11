import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

/// Provider class for managing task state and operations
class TaskProvider with ChangeNotifier {
  // Private fields
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

  // Service instance
  final ApiService _apiService = ApiService.instance;

  // Getters
  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMorePages => _hasMorePages;
  int get totalTasks => _totalTasks;
  String? get statusFilter => _statusFilter;
  String? get priorityFilter => _priorityFilter;
  String? get searchQuery => _searchQuery;

  /// Check if there are any tasks
  bool get hasTasks => _tasks.isNotEmpty;

  /// Check if filters are active
  bool get hasActiveFilters =>
      _statusFilter != null ||
      _priorityFilter != null ||
      (_searchQuery != null && _searchQuery!.isNotEmpty);

  /// Load tasks with optional filters
  Future<void> loadTasks({
    String? status,
    String? priority,
    String? search,
    bool refresh = false,
  }) async {
    try {
      // Update filters
      _statusFilter = status;
      _priorityFilter = priority;
      _searchQuery = search;

      if (refresh) {
        _currentPage = 1;
        _tasks.clear();
      }

      _setLoading(true);
      _setError(null);

      Logger.info(
        'Loading tasks - Page: $_currentPage, Status: $status, Priority: $priority, Search: $search',
      );

      final response = await _apiService.getTasks(
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

      Logger.success('Loaded ${response.data.length} tasks successfully');
    } catch (e) {
      Logger.error('Failed to load tasks: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load more tasks (pagination)
  Future<void> loadMoreTasks() async {
    if (_isLoading || !_hasMorePages) return;

    Logger.info('Loading more tasks - Page: ${_currentPage + 1}');

    try {
      _setLoading(true);

      final response = await _apiService.getTasks(
        status: _statusFilter,
        priority: _priorityFilter,
        search: _searchQuery,
        page: _currentPage + 1,
      );

      _tasks.addAll(response.data);
      _currentPage = response.currentPage;
      _hasMorePages = response.hasMorePages;
      _totalTasks = response.total;

      Logger.success('Loaded ${response.data.length} more tasks');
    } catch (e) {
      Logger.error('Failed to load more tasks: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Get a specific task by ID
  Future<Task?> getTask(int id) async {
    try {
      Logger.info('Fetching task with ID: $id');

      final task = await _apiService.getTask(id);

      // Update task in local list if it exists
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }

      Logger.success('Fetched task successfully: ${task.title}');
      return task;
    } catch (e) {
      Logger.error('Failed to get task: $e');
      _setError(e.toString());
      return null;
    }
  }

  /// Create a new task
  Future<bool> createTask(Task task) async {
    try {
      Logger.info('Creating new task: ${task.title}');

      final createdTask = await _apiService.createTask(task);

      // Add to the beginning of the list
      _tasks.insert(0, createdTask);
      _totalTasks++;

      Logger.success('Task created successfully: ${createdTask.title}');
      notifyListeners();
      return true;
    } catch (e) {
      Logger.error('Failed to create task: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Update an existing task
  Future<bool> updateTask(Task task) async {
    if (task.id == null) {
      Logger.error('Cannot update task without ID');
      return false;
    }

    try {
      Logger.info('Updating task: ${task.title}');

      final updatedTask = await _apiService.updateTask(task.id!, task);

      // Update task in local list
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }

      Logger.success('Task updated successfully: ${updatedTask.title}');
      return true;
    } catch (e) {
      Logger.error('Failed to update task: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(int id) async {
    try {
      Logger.info('Deleting task with ID: $id');

      await _apiService.deleteTask(id);

      // Remove from local list
      _tasks.removeWhere((task) => task.id == id);
      _totalTasks--;

      Logger.success('Task deleted successfully');
      notifyListeners();
      return true;
    } catch (e) {
      Logger.error('Failed to delete task: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Refresh tasks (reload first page)
  Future<void> refreshTasks() async {
    Logger.info('Refreshing tasks');

    await loadTasks(
      status: _statusFilter,
      priority: _priorityFilter,
      search: _searchQuery,
      refresh: true,
    );
  }

  /// Clear all filters
  void clearFilters() {
    Logger.info('Clearing all filters');

    _statusFilter = null;
    _priorityFilter = null;
    _searchQuery = null;

    // Reload tasks without filters
    loadTasks(refresh: true);
  }

  /// Set status filter
  void setStatusFilter(String? status) {
    if (_statusFilter != status) {
      Logger.info('Setting status filter: $status');
      loadTasks(
        status: status,
        priority: _priorityFilter,
        search: _searchQuery,
        refresh: true,
      );
    }
  }

  /// Set priority filter
  void setPriorityFilter(String? priority) {
    if (_priorityFilter != priority) {
      Logger.info('Setting priority filter: $priority');
      loadTasks(
        status: _statusFilter,
        priority: priority,
        search: _searchQuery,
        refresh: true,
      );
    }
  }

  /// Set search query
  void setSearchQuery(String? search) {
    if (_searchQuery != search) {
      Logger.info('Setting search query: $search');
      loadTasks(
        status: _statusFilter,
        priority: _priorityFilter,
        search: search,
        refresh: true,
      );
    }
  }

  /// Get tasks by status
  List<Task> getTasksByStatus(String status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  /// Get tasks by priority
  List<Task> getTasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  /// Get completed tasks count
  int get completedTasksCount => _tasks
      .where((task) => task.status == AppConstants.statusCompleted)
      .length;

  /// Get pending tasks count
  int get pendingTasksCount =>
      _tasks.where((task) => task.status == AppConstants.statusPending).length;

  /// Get in progress tasks count
  int get inProgressTasksCount => _tasks
      .where((task) => task.status == AppConstants.statusInProgress)
      .length;

  /// Test API connection
  Future<bool> testConnection() async {
    try {
      Logger.info('Testing API connection');

      final isConnected = await _apiService.testConnection();

      if (isConnected) {
        Logger.success('API connection test successful');
      } else {
        Logger.warning('API connection test failed');
      }

      return isConnected;
    } catch (e) {
      Logger.error('API connection test error: $e');
      return false;
    }
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }
}
