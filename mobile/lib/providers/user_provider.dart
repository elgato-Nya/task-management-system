import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../utils/logger.dart';

/// Provider class for managing user state and operations
class UserProvider with ChangeNotifier {
  // Private fields
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMorePages = false;
  int _totalUsers = 0;

  // Service instance
  final ApiService _apiService = ApiService.instance;

  // Getters
  List<User> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMorePages => _hasMorePages;
  int get totalUsers => _totalUsers;

  /// Check if there are any users
  bool get hasUsers => _users.isNotEmpty;

  /// Load users with pagination
  Future<void> loadUsers({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _users.clear();
      }

      _setLoading(true);
      _setError(null);

      Logger.info('Loading users - Page: $_currentPage');

      final response = await _apiService.getUsers(page: _currentPage);

      if (refresh) {
        _users = response.data;
      } else {
        _users.addAll(response.data);
      }

      _currentPage = response.currentPage;
      _hasMorePages = response.hasMorePages;
      _totalUsers = response.total;

      Logger.success('Loaded ${response.data.length} users successfully');
    } catch (e) {
      Logger.error('Failed to load users: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load more users (pagination)
  Future<void> loadMoreUsers() async {
    if (_isLoading || !_hasMorePages) return;

    Logger.info('Loading more users - Page: ${_currentPage + 1}');

    try {
      _setLoading(true);

      final response = await _apiService.getUsers(page: _currentPage + 1);

      _users.addAll(response.data);
      _currentPage = response.currentPage;
      _hasMorePages = response.hasMorePages;
      _totalUsers = response.total;

      Logger.success('Loaded ${response.data.length} more users');
    } catch (e) {
      Logger.error('Failed to load more users: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Get a specific user by ID
  Future<User?> getUser(int id) async {
    try {
      Logger.info('Fetching user with ID: $id');

      final user = await _apiService.getUser(id);

      // Update user in local list if it exists
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }

      Logger.success('Fetched user successfully: ${user.name}');
      return user;
    } catch (e) {
      Logger.error('Failed to get user: $e');
      _setError(e.toString());
      return null;
    }
  }

  /// Create a new user
  Future<bool> createUser(User user) async {
    try {
      Logger.info('Creating new user: ${user.name}');

      final createdUser = await _apiService.createUser(user);

      // Add to the beginning of the list
      _users.insert(0, createdUser);
      _totalUsers++;

      Logger.success('User created successfully: ${createdUser.name}');
      notifyListeners();
      return true;
    } catch (e) {
      Logger.error('Failed to create user: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Update an existing user
  Future<bool> updateUser(User user) async {
    if (user.id == null) {
      Logger.error('Cannot update user without ID');
      return false;
    }

    try {
      Logger.info('Updating user: ${user.name}');

      final updatedUser = await _apiService.updateUser(user.id!, user);

      // Update user in local list
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = updatedUser;
        notifyListeners();
      }

      Logger.success('User updated successfully: ${updatedUser.name}');
      return true;
    } catch (e) {
      Logger.error('Failed to update user: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Delete a user
  Future<bool> deleteUser(int id) async {
    try {
      Logger.info('Deleting user with ID: $id');

      await _apiService.deleteUser(id);

      // Remove from local list
      _users.removeWhere((user) => user.id == id);
      _totalUsers--;

      Logger.success('User deleted successfully');
      notifyListeners();
      return true;
    } catch (e) {
      Logger.error('Failed to delete user: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Refresh users (reload first page)
  Future<void> refreshUsers() async {
    Logger.info('Refreshing users');
    await loadUsers(refresh: true);
  }

  /// Get user by ID from local list
  User? getUserById(int id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search users by query
  Future<void> searchUsers(String? query) async {
    try {
      _currentPage = 1;
      _users.clear();

      _setLoading(true);
      _setError(null);

      Logger.info('Searching users with query: $query');

      final response = await _apiService.getUsers(
        page: _currentPage,
        search: query,
      );

      _users = response.data;
      _currentPage = response.currentPage;
      _hasMorePages = response.hasMorePages;
      _totalUsers = response.total;

      Logger.success('Found ${response.data.length} users');
    } catch (e) {
      Logger.error('Failed to search users: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
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
