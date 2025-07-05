import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task.dart';
import '../models/api_response.dart';

class ApiService {
  static Future<PaginatedResponse<Task>> getTasks({
    String? status,
    String? priority,
    String? search,
    int page = 1,
  }) async {
    try {
      var url = '${ApiConfig.baseUrl}/tasks?page=$page';
      
      if (status != null && status.isNotEmpty) url += '&status=$status';
      if (priority != null && priority.isNotEmpty) url += '&priority=$priority';
      if (search != null && search.isNotEmpty) url += '&search=${Uri.encodeComponent(search)}';

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true) {
          return PaginatedResponse.fromJson(
            jsonData['data'],
            (json) => Task.fromJson(json),
          );
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to load tasks');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load tasks');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } on http.ClientException {
      throw Exception('Connection failed. Please check if the server is running.');
    } catch (e) {
      throw Exception('Error loading tasks: ${e.toString()}');
    }
  }

  static Future<Task> getTask(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true) {
          return Task.fromJson(jsonData['data']);
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to load task');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Task not found');
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load task');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } on http.ClientException {
      throw Exception('Connection failed. Please check if the server is running.');
    } catch (e) {
      throw Exception('Error loading task: ${e.toString()}');
    }
  }

  static Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks'),
        headers: ApiConfig.headers,
        body: json.encode(task.toJson()),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true) {
          return Task.fromJson(jsonData['data']);
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to create task');
        }
      } else if (response.statusCode == 422) {
        final jsonData = json.decode(response.body);
        final errors = jsonData['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final errorMessages = errors.values
              .expand((e) => e as List)
              .join(', ');
          throw Exception('Validation errors: $errorMessages');
        }
        throw Exception('Validation failed');
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to create task');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } on http.ClientException {
      throw Exception('Connection failed. Please check if the server is running.');
    } catch (e) {
      throw Exception('Error creating task: ${e.toString()}');
    }
  }

  static Future<Task> updateTask(int id, Task task) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
        headers: ApiConfig.headers,
        body: json.encode(task.toJson()),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true) {
          return Task.fromJson(jsonData['data']);
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to update task');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Task not found');
      } else if (response.statusCode == 422) {
        final jsonData = json.decode(response.body);
        final errors = jsonData['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final errorMessages = errors.values
              .expand((e) => e as List)
              .join(', ');
          throw Exception('Validation errors: $errorMessages');
        }
        throw Exception('Validation failed');
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to update task');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } on http.ClientException {
      throw Exception('Connection failed. Please check if the server is running.');
    } catch (e) {
      throw Exception('Error updating task: ${e.toString()}');
    }
  }

  static Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] != true) {
          throw Exception(jsonData['message'] ?? 'Failed to delete task');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Task not found');
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to delete task');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } on http.ClientException {
      throw Exception('Connection failed. Please check if the server is running.');
    } catch (e) {
      throw Exception('Error deleting task: ${e.toString()}');
    }
  }

  // Helper method to test API connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks?page=1'),
        headers: ApiConfig.headers,
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
