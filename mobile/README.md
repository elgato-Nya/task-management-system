# Personal Task Management App (Flutter)

A beautiful, modern Flutter mobile application for personal task management. Built with Material 3 design and integrated with Laravel backend API.

## 🚀 Features

### 📱 Core Functionality
- **Task Management**: Create, edit, delete, and view tasks with ease
- **Smart Filtering**: Filter tasks by status (pending, in progress, completed) and priority (low, medium, high)
- **Search**: Quick search through task titles and descriptions
- **Due Dates**: Set and track task deadlines
- **Task Status**: Visual status indicators with color coding
- **Priority Levels**: Low, Medium, High priority with distinct visual representations

### 🎨 User Interface
- **Material 3 Design**: Modern, clean interface following latest Material Design guidelines
- **Theme Support**: Light, dark, and system theme modes with persistent settings
- **Responsive Layout**: Optimized for different screen sizes
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Intuitive Navigation**: Easy-to-use navigation with bottom navigation bar

### 🔄 Data Management
- **API Integration**: Seamless communication with Laravel backend
- **State Management**: Provider pattern for efficient state handling
- **Local Storage**: Theme preferences and settings persistence
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Loading States**: Visual feedback during data operations

## 📋 Prerequisites

- Flutter SDK (3.16.0 or later)
- Dart SDK (3.2.0 or later)
- Android Studio / VS Code with Flutter extension
- Android/iOS device or emulator
- Laravel backend running (see backend README)

## 🛠️ Setup Instructions

### 1. Install Flutter Dependencies

```bash
cd mobile
flutter pub get
```

### 2. Configure API Base URL

Update `lib/config/network_config.dart`:

```dart
class NetworkConfig {
  // For Android emulator connecting to local Laravel server
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // For iOS simulator connecting to local Laravel server
  // static const String baseUrl = 'http://127.0.0.1:8000';
  
  // For physical device on same network (replace with your computer's IP)
  // static const String baseUrl = 'http://192.168.1.100:8000';
}
```

### 3. Run the Application

```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

## 📁 Key Files

```
mobile/
├── lib/
│   ├── config/
│   │   ├── app_config.dart           # App configuration
│   │   ├── network_config.dart       # API endpoints
│   │   └── theme_config.dart         # Theme configuration
│   ├── models/
│   │   └── task.dart                 # Task data model
│   ├── providers/
│   │   ├── task_provider.dart        # Task state management
│   │   └── theme_provider.dart       # Theme state management
│   ├── screens/
│   │   ├── task_list_screen.dart     # Main task list
│   │   ├── task_form_screen.dart     # Task creation/editing
│   │   └── task_detail_screen.dart   # Task details view
│   ├── services/
│   │   └── api_service.dart          # API communication
│   └── widgets/
│       ├── task_card.dart            # Task display card
│       └── common UI widgets
│   └── main.dart                     # App entry point
└── pubspec.yaml                      # Dependencies
```

## 🎯 Features Overview

### Task Management
- **Create Tasks**: Add new tasks with title, description, priority, and due date
- **Edit Tasks**: Update existing tasks with full editing capabilities
- **Delete Tasks**: Remove tasks with confirmation dialog
- **Status Management**: Track task progress (pending, in progress, completed)
- **Priority Levels**: Organize tasks by priority (low, medium, high)

### User Interface
- **Material 3 Design**: Modern, clean interface following latest design guidelines
- **Theme Support**: Light, dark, and system theme modes
- **Responsive Layout**: Works perfectly on different screen sizes
- **Smooth Animations**: Fluid transitions and micro-interactions

### Data & State Management
- **Provider Pattern**: Efficient state management for tasks and themes
- **API Integration**: Seamless communication with Laravel backend
- **Local Storage**: Persistent theme preferences
- **Error Handling**: User-friendly error messages and loading states

## 🚨 Important Notes

1. **Backend Required**: Make sure the Laravel backend is running at the configured API URL
2. **API Configuration**: Update `network_config.dart` with correct backend URL
3. **Permissions**: App may request internet permissions for API calls
4. **Testing**: Use debug mode for development and testing
# For Android
flutter run

# For iOS (macOS only)
flutter run --device ios

# For web
flutter run -d chrome
```

## 📱 Required Dependencies

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0                    # HTTP requests
  provider: ^6.1.1                # State management
  intl: ^0.19.0                   # Date formatting
  shared_preferences: ^2.2.2      # Local storage
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 📂 Recommended Project Structure

```
lib/
├── config/
│   └── api_config.dart          # API configuration
├── models/
│   ├── task.dart                # Task model
│   └── user.dart                # User model
├── services/
│   └── api_service.dart         # API service layer
├── providers/
│   └── task_provider.dart       # State management
├── screens/
│   ├── task_list_screen.dart    # Task list view
│   ├── task_detail_screen.dart  # Task details
│   ├── create_task_screen.dart  # Create new task
│   └── edit_task_screen.dart    # Edit existing task
├── widgets/
│   ├── task_card.dart           # Task card widget
│   ├── filter_widget.dart       # Filter controls
│   └── loading_widget.dart      # Loading indicator
└── main.dart                    # App entry point
```

## 🔧 Implementation Examples

### 1. Task Model (`lib/models/task.dart`)

```dart
class Task {
  final int? id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final int userId;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'user_id': userId,
    };
  }
}
```

### 2. API Service (`lib/services/api_service.dart`)

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task.dart';

class ApiService {
  static Future<List<Task>> getTasks({
    String? status,
    String? priority,
    String? search,
    int page = 1,
  }) async {
    var url = '${ApiConfig.baseUrl}/tasks?page=$page';
    
    if (status != null) url += '&status=$status';
    if (priority != null) url += '&priority=$priority';
    if (search != null) url += '&search=$search';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tasksJson = data['data']['data'] as List;
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Task.fromJson(data['data']);
    } else {
      throw Exception('Failed to create task');
    }
  }

  static Future<Task> updateTask(int id, Task task) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Task.fromJson(data['data']);
    } else {
      throw Exception('Failed to update task');
    }
  }

  static Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
```

### 3. Task Provider (`lib/providers/task_provider.dart`)

```dart
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTasks({
    String? status,
    String? priority,
    String? search,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await ApiService.getTasks(
        status: status,
        priority: priority,
        search: search,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    try {
      final newTask = await ApiService.createTask(task);
      _tasks.insert(0, newTask);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

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
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await ApiService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
```

## 🌐 API Integration Notes

### Network Configuration

1. **Android Emulator**: Use `10.0.2.2:8000` to connect to localhost
2. **iOS Simulator**: Use `127.0.0.1:8000` to connect to localhost
3. **Physical Device**: Use your computer's IP address (e.g., `192.168.1.100:8000`)

### Error Handling

Always wrap API calls in try-catch blocks and provide user feedback:

```dart
try {
  await provider.createTask(task);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Task created successfully')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

### Internet Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 🔗 Backend Integration

Make sure your Laravel backend is running:

```bash
cd ../backend
php artisan serve
```

The mobile app will connect to the API endpoints at `http://localhost:8000/api/tasks`.

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📱 Building for Production

### Android APK
```bash
flutter build apk --release
```

### iOS App (macOS only)
```bash
flutter build ios --release
```

## 🚨 Common Issues

1. **Network Connection**: Ensure Laravel server is running and accessible
2. **CORS Issues**: CORS is already configured in the Laravel backend
3. **API Timeout**: Add timeout handling to HTTP requests
4. **SSL Certificates**: Use HTTP for development, HTTPS for production

## 📖 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [HTTP Package](https://pub.dev/packages/http)
- [Provider Package](https://pub.dev/packages/provider)
- [Laravel API Documentation](../API_DOCUMENTATION.md)
