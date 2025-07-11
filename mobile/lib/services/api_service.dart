import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../config/network_config.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../models/api_response.dart';
import '../utils/logger.dart';

/// Service class for handling API communication
class ApiService {
  /// Private constructor to prevent instantiation
  ApiService._();

  /// Singleton instance
  static final ApiService _instance = ApiService._();

  /// Get singleton instance
  static ApiService get instance => _instance;

  /// Get paginated list of tasks
  Future<PaginatedResponse<Task>> getTasks({
    String? status,
    String? priority,
    String? search,
    int page = 1,
  }) async {
    try {
      final url = NetworkConfig.getTasksUrl(
        page: page,
        status: status,
        priority: priority,
        search: search,
      );

      Logger.debug('Fetching tasks from: $url');

      final response = await http
          .get(Uri.parse(url), headers: AppConfig.defaultHeaders)
          .timeout(AppConfig.requestTimeout);

      Logger.debug('Response status: ${response.statusCode}');

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final paginatedResponse = PaginatedResponse.fromJson(
            jsonData['data'],
            (json) => Task.fromJson(json),
          );

          Logger.debug(
            'Successfully fetched ${paginatedResponse.data.length} tasks',
          );
          return paginatedResponse;
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to load tasks',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } on TimeoutException catch (e) {
      Logger.error('Timeout exception: $e');
      throw NetworkException('Request timed out. Please try again.');
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error loading tasks: ${e.toString()}');
    }
  }

  /// Get a specific task by ID
  Future<Task> getTask(int id) async {
    try {
      final url = NetworkConfig.getTaskUrl(id);
      Logger.debug('Fetching task from: $url');

      final response = await http
          .get(Uri.parse(url), headers: AppConfig.defaultHeaders)
          .timeout(AppConfig.requestTimeout);

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          return Task.fromJson(jsonData['data']);
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to load task',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error loading task: ${e.toString()}');
    }
  }

  /// Create a new task
  Future<Task> createTask(Task task) async {
    try {
      final url = NetworkConfig.getApiUrl(NetworkConfig.tasksEndpoint);
      Logger.debug('Creating task at: $url');

      final response = await http
          .post(
            Uri.parse(url),
            headers: AppConfig.defaultHeaders,
            body: json.encode(task.toJson()),
          )
          .timeout(AppConfig.requestTimeout);

      if (response.statusCode == NetworkConfig.statusCreated) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          return Task.fromJson(jsonData['data']);
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to create task',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error creating task: ${e.toString()}');
    }
  }

  /// Update an existing task
  Future<Task> updateTask(int id, Task task) async {
    try {
      final url = NetworkConfig.getTaskUrl(id);
      Logger.debug('Updating task at: $url');

      final response = await http
          .put(
            Uri.parse(url),
            headers: AppConfig.defaultHeaders,
            body: json.encode(task.toJson()),
          )
          .timeout(AppConfig.requestTimeout);

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          return Task.fromJson(jsonData['data']);
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to update task',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error updating task: ${e.toString()}');
    }
  }

  /// Delete a task
  Future<void> deleteTask(int id) async {
    try {
      final url = NetworkConfig.getTaskUrl(id);
      Logger.debug('Deleting task at: $url');

      final response = await http
          .delete(Uri.parse(url), headers: AppConfig.defaultHeaders)
          .timeout(AppConfig.requestTimeout);

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] != true) {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to delete task',
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == NetworkConfig.statusNotFound) {
        throw ApiException(
          message: 'Task not found',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error deleting task: ${e.toString()}');
    }
  }

  /// Get paginated list of users
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    String? search,
  }) async {
    try {
      final url = NetworkConfig.getUsersUrl(page: page, search: search);
      Logger.debug('Fetching users from: $url');

      final response = await http
          .get(Uri.parse(url), headers: AppConfig.defaultHeaders)
          .timeout(AppConfig.requestTimeout);

      Logger.debug('Response status: ${response.statusCode}');

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final paginatedResponse = PaginatedResponse.fromJson(
            jsonData['data'],
            (json) => User.fromJson(json),
          );

          Logger.debug(
            'Successfully fetched ${paginatedResponse.data.length} users',
          );
          return paginatedResponse;
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to load users',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } on TimeoutException catch (e) {
      Logger.error('Timeout exception: $e');
      throw NetworkException('Request timed out. Please try again.');
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error loading users: ${e.toString()}');
    }
  }

  /// Get a specific user by ID
  Future<User> getUser(int id) async {
    try {
      final url = NetworkConfig.getUserUrl(id);
      Logger.debug('Fetching user from: $url');

      final response = await http
          .get(Uri.parse(url), headers: AppConfig.defaultHeaders)
          .timeout(AppConfig.requestTimeout);

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          return User.fromJson(jsonData['data']);
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to load user',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error loading user: ${e.toString()}');
    }
  }

  /// Create a new user
  Future<User> createUser(User user) async {
    try {
      final url = NetworkConfig.getApiUrl('users');
      Logger.debug('Creating user at: $url');

      final response = await http
          .post(
            Uri.parse(url),
            headers: AppConfig.defaultHeaders,
            body: json.encode(user.toJson()),
          )
          .timeout(AppConfig.requestTimeout);

      if (response.statusCode == NetworkConfig.statusCreated) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          return User.fromJson(jsonData['data']);
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to create user',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error creating user: ${e.toString()}');
    }
  }

  /// Update an existing user
  Future<User> updateUser(int id, User user) async {
    try {
      final url = NetworkConfig.getUserUrl(id);
      Logger.debug('Updating user at: $url');

      final response = await http
          .put(
            Uri.parse(url),
            headers: AppConfig.defaultHeaders,
            body: json.encode(user.toJson()),
          )
          .timeout(AppConfig.requestTimeout);

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          return User.fromJson(jsonData['data']);
        } else {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to update user',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error updating user: ${e.toString()}');
    }
  }

  /// Delete a user
  Future<void> deleteUser(int id) async {
    try {
      final url = NetworkConfig.getUserUrl(id);
      Logger.debug('Deleting user at: $url');

      final response = await http
          .delete(Uri.parse(url), headers: AppConfig.defaultHeaders)
          .timeout(AppConfig.requestTimeout);

      if (NetworkConfig.isSuccessStatusCode(response.statusCode)) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] != true) {
          throw ApiException(
            message: jsonData['message'] ?? 'Failed to delete user',
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == NetworkConfig.statusNotFound) {
        throw ApiException(
          message: 'User not found',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          message:
              'HTTP ${response.statusCode}: ${_getErrorMessage(response.statusCode)}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      Logger.error('Socket exception: $e');
      throw NetworkException(AppConfig.networkErrorMessage);
    } on http.ClientException catch (e) {
      Logger.error('Client exception: $e');
      throw NetworkException(
        'Connection failed. Please check if the server is running.',
      );
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException(message: 'Error deleting user: ${e.toString()}');
    }
  }

  /// Test API connection
  Future<bool> testConnection() async {
    try {
      final url = NetworkConfig.getTasksUrl(page: 1);
      Logger.debug('Testing connection to: $url');

      final response = await http
          .get(Uri.parse(url), headers: AppConfig.defaultHeaders)
          .timeout(const Duration(seconds: 10));

      final isConnected = NetworkConfig.isSuccessStatusCode(
        response.statusCode,
      );
      Logger.debug('Connection test result: $isConnected');

      return isConnected;
    } catch (e) {
      Logger.error('Connection test failed: $e');
      return false;
    }
  }

  /// Get user-friendly error message based on status code
  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case NetworkConfig.statusBadRequest:
        return 'Bad request. Please check your input.';
      case NetworkConfig.statusUnauthorized:
        return 'Unauthorized. Please login again.';
      case NetworkConfig.statusForbidden:
        return 'Access forbidden.';
      case NetworkConfig.statusNotFound:
        return 'Resource not found.';
      case NetworkConfig.statusInternalServerError:
        return 'Internal server error. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

/// Base exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}

/// Exception for network-related errors
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for timeout errors
class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
