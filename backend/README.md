# Task Management System - Backend (Laravel)

This is the backend API and web interface for the Personal Task Management System, built with Laravel 11 and MySQL.

## 🚀 Features

### 📊 Web Interface (Laravel + Blade)
- **Task Dashboard**: Complete overview of all tasks with filtering
- **CRUD Operations**: Create, edit, delete, and view tasks
- **Advanced Filtering**: Filter by status, priority, and search functionality
- **Responsive Design**: Bootstrap 5 with mobile-friendly interface
- **Form Validation**: Client-side and server-side validation
- **Pagination**: Efficient handling of large task lists

### 🔌 REST API
- **RESTful Endpoints**: Standard REST API for mobile app integration
- **JSON Responses**: Structured, consistent API responses
- **CORS Support**: Cross-origin requests enabled for mobile apps
- **Input Validation**: Server-side validation for all API requests
- **Error Handling**: Comprehensive error responses with proper HTTP status codes

### 🗄️ Database
- **MySQL Integration**: Optimized for MySQL/phpMyAdmin
- **Migration System**: Version-controlled database schema
- **Model Relationships**: Proper Eloquent model setup
- **Database Seeding**: Sample data generation for testing

## 📁 Project Structure

```
backend/
├── app/
│   ├── Http/Controllers/
│   │   ├── TaskController.php        # Web interface controller
│   │   └── Api/TaskController.php    # API controller
│   ├── Http/Requests/
│   │   ├── StoreTaskRequest.php      # Task creation validation
│   │   └── UpdateTaskRequest.php     # Task update validation
│   ├── Models/
│   │   └── Task.php                  # Task Eloquent model
│   └── Providers/
├── database/
│   ├── migrations/
│   │   └── *_create_tasks_table.php  # Task table migration
│   ├── factories/
│   │   └── TaskFactory.php           # Task factory for seeding
│   └── seeders/
│       └── TaskSeeder.php            # Sample data seeder
├── resources/
│   └── views/
│       ├── layouts/
│       │   └── app.blade.php         # Main layout template
│       └── tasks/                    # Task-related views
│           ├── index.blade.php       # Task list view
│           ├── create.blade.php      # Task creation form
│           ├── edit.blade.php        # Task editing form
│           └── show.blade.php        # Task detail view
├── routes/
│   ├── web.php                       # Web routes
│   └── api.php                       # API routes
└── config/
    └── database.php                  # Database configuration
```

## 🛠️ Installation & Setup

### Prerequisites
- PHP 8.2 or higher
- Composer
- MySQL 8.0 or higher
- Node.js & npm (for frontend assets)

### Setup Steps

1. **Install Dependencies**
   ```bash
   composer install
   npm install
   ```

2. **Environment Configuration**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

3. **Database Setup**
   ```bash
   # Update .env with your database credentials
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=task_management
   DB_USERNAME=your_username
   DB_PASSWORD=your_password
   ```

4. **Database Migration & Seeding**
   ```bash
   php artisan migrate:fresh --seed
   ```

5. **Start Development Server**
   ```bash
   php artisan serve
   ```

   Access the web interface at: `http://localhost:8000`

## 🔗 API Endpoints

### Task Management
- `GET /api/tasks` - List all tasks with filtering
- `POST /api/tasks` - Create new task
- `GET /api/tasks/{id}` - Get specific task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task

### Example API Calls

**Get all tasks:**
```bash
curl -X GET "http://localhost:8000/api/tasks"
```

**Create a task:**
```bash
curl -X POST "http://localhost:8000/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Task",
    "description": "Task description",
    "status": "pending",
    "priority": "medium"
  }'
```

## 📊 Database Schema

### Tasks Table
- `id` - Primary key
- `title` - Task title (required)
- `description` - Task description (nullable)
- `status` - enum: pending, in_progress, completed
- `priority` - enum: low, medium, high
- `due_date` - Deadline (nullable)
- `created_at` - Timestamp
- `updated_at` - Timestamp

## 🧪 Sample Data

The system includes seeders that create 25 sample tasks with random data and various combinations of status, priority, and due dates.

## 🚨 Important Notes

1. **Database**: Make sure MySQL is running and database exists
2. **Environment**: Update `.env` file with correct database credentials
3. **CORS**: API is configured for open CORS (adjust for production)
4. **Validation**: All inputs are validated on both client and server side
