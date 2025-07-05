import 'user.dart';

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
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'user_id': userId,
    };
  }

  // Helper methods for status and priority
  static List<String> get statusOptions => ['pending', 'in_progress', 'completed'];
  static List<String> get priorityOptions => ['low', 'medium', 'high'];

  // Helper method to get status display name
  String get statusDisplayName {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'pending':
      default:
        return 'Pending';
    }
  }

  // Helper method to get priority display name
  String get priorityDisplayName {
    return priority[0].toUpperCase() + priority.substring(1);
  }

  // Helper method to check if task is overdue
  bool get isOverdue {
    if (dueDate == null || status == 'completed') return false;
    return dueDate!.isBefore(DateTime.now());
  }

  // Copy with method for easy updates
  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    int? userId,
    User? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
