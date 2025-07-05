# Task Management System API Documentation

## Base URL
```
http://localhost:8000/api
```

## Endpoints

### Get All Tasks
**GET** `/tasks`

**Parameters:**
- `status` (optional): Filter by status (`pending`, `in_progress`, `completed`)
- `priority` (optional): Filter by priority (`low`, `medium`, `high`)
- `search` (optional): Search in title and description
- `page` (optional): Page number for pagination

**Example:**
```
GET /api/tasks?status=pending&priority=high&search=urgent&page=1
```

**Response:**
```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "id": 1,
                "title": "Complete project documentation",
                "description": "Write comprehensive documentation for the task management system",
                "status": "pending",
                "priority": "high",
                "due_date": "2025-07-10T10:00:00.000000Z",
                "user_id": 1,
                "created_at": "2025-07-05T17:30:00.000000Z",
                "updated_at": "2025-07-05T17:30:00.000000Z",
                "user": {
                    "id": 1,
                    "name": "John Doe",
                    "email": "john@example.com"
                }
            }
        ],
        "from": 1,
        "last_page": 3,
        "per_page": 10,
        "to": 10,
        "total": 25
    }
}
```

### Get Single Task
**GET** `/tasks/{id}`

**Response:**
```json
{
    "success": true,
    "data": {
        "id": 1,
        "title": "Complete project documentation",
        "description": "Write comprehensive documentation for the task management system",
        "status": "pending",
        "priority": "high",
        "due_date": "2025-07-10T10:00:00.000000Z",
        "user_id": 1,
        "created_at": "2025-07-05T17:30:00.000000Z",
        "updated_at": "2025-07-05T17:30:00.000000Z",
        "user": {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com"
        }
    }
}
```

### Create Task
**POST** `/tasks`

**Request Body:**
```json
{
    "title": "Complete project documentation",
    "description": "Write comprehensive documentation for the task management system",
    "status": "pending",
    "priority": "high",
    "due_date": "2025-07-10T10:00:00",
    "user_id": 1
}
```

**Required Fields:**
- `title` (string, max 255 characters)
- `status` (enum: `pending`, `in_progress`, `completed`)
- `priority` (enum: `low`, `medium`, `high`)
- `user_id` (integer, must exist in users table)

**Optional Fields:**
- `description` (string)
- `due_date` (datetime)

**Response:**
```json
{
    "success": true,
    "message": "Task created successfully",
    "data": {
        "id": 1,
        "title": "Complete project documentation",
        "description": "Write comprehensive documentation for the task management system",
        "status": "pending",
        "priority": "high",
        "due_date": "2025-07-10T10:00:00.000000Z",
        "user_id": 1,
        "created_at": "2025-07-05T17:30:00.000000Z",
        "updated_at": "2025-07-05T17:30:00.000000Z",
        "user": {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com"
        }
    }
}
```

### Update Task
**PUT** `/tasks/{id}`

**Request Body:** Same as Create Task

**Response:**
```json
{
    "success": true,
    "message": "Task updated successfully",
    "data": {
        // Updated task data
    }
}
```

### Delete Task
**DELETE** `/tasks/{id}`

**Response:**
```json
{
    "success": true,
    "message": "Task deleted successfully"
}
```

## Error Responses

### Validation Error (422)
```json
{
    "message": "The given data was invalid.",
    "errors": {
        "title": [
            "The title field is required."
        ],
        "status": [
            "The selected status is invalid."
        ]
    }
}
```

### Not Found (404)
```json
{
    "message": "No query results for model [App\\Models\\Task] 1"
}
```

## Status Codes
- `200` - Success
- `201` - Created
- `404` - Not Found
- `422` - Validation Error
- `500` - Server Error

## CORS
All API endpoints support CORS with the following headers:
- `Access-Control-Allow-Origin: *`
- `Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS`
- `Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With`

## Examples for Mobile App

### Fetch Tasks (Flutter/Dart example)
```dart
Future<List<Task>> fetchTasks() async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/tasks'),
    headers: {'Content-Type': 'application/json'},
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['data']['data'] as List)
        .map((json) => Task.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load tasks');
  }
}
```

### Create Task (Flutter/Dart example)
```dart
Future<Task> createTask(Task task) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/tasks'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'title': task.title,
      'description': task.description,
      'status': task.status,
      'priority': task.priority,
      'due_date': task.dueDate?.toIso8601String(),
      'user_id': task.userId,
    }),
  );
  
  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    return Task.fromJson(data['data']);
  } else {
    throw Exception('Failed to create task');
  }
}
```
