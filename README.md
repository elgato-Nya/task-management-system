# Task Management System

A full-stack task management system built with Laravel (backend), Blade templates (web UI), and designed to work with Flutter mobile app through REST API.

## 🚀 Features

### Web Interface (Laravel + Blade)
- **CRUD Operations**: Create, Read, Update, Delete tasks
- **Advanced Filtering**: Filter by status, priority, and search
- **Beautiful UI**: Modern Bootstrap 5 interface with responsive design
- **Dark Mode**: Toggle between light and dark themes with persistence
- **Task Status**: Pending, In Progress, Completed
- **Priority Levels**: Low, Medium, High with color coding
- **Due Dates**: Set and track task deadlines
- **User Assignment**: Assign tasks to users
- **Pagination**: Navigate through large task lists

### API (Laravel REST API)
- **RESTful Endpoints**: Standard REST API for mobile integration
- **JSON Responses**: Structured JSON responses for easy parsing
- **CORS Support**: Cross-origin requests enabled for mobile apps
- **Filtering & Search**: Same filtering capabilities as web interface
- **Validation**: Server-side validation for all inputs

### Database
- **MySQL Support**: Configured for MySQL/phpMyAdmin
- **Migrations**: Database structure versioning
- **Seeders**: Sample data generation
- **Relationships**: Proper user-task relationships

## 📁 Project Structure

```
task-management-system/
├── backend/                 # Laravel application
│   ├── app/
│   │   ├── Http/Controllers/
│   │   │   ├── TaskController.php      # Web controller
│   │   │   └── Api/TaskController.php  # API controller
│   │   └── Models/
│   │       └── Task.php               # Task model
│   ├── database/
│   │   ├── migrations/
│   │   ├── factories/
│   │   └── seeders/
│   ├── resources/views/tasks/         # Blade templates
│   └── routes/
│       ├── web.php                    # Web routes
│       └── api.php                    # API routes
├── mobile/                  # Flutter application
└── API_DOCUMENTATION.md     # API documentation
```

## 🛠️ Installation & Setup

### Prerequisites
- PHP 8.2+
- Composer
- MySQL
- Laravel 12.0+

### Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   composer install
   ```

3. **Configure environment**
   - Copy `.env.example` to `.env` (already done)
   - Update database configuration in `.env`:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=task_management_db
   DB_USERNAME=root
   DB_PASSWORD=
   ```

4. **Create database**
   ```sql
   CREATE DATABASE task_management_db;
   ```

5. **Generate application key**
   ```bash
   php artisan key:generate
   ```

6. **Run migrations and seed data**
   ```bash
   php artisan migrate:fresh --seed
   ```

7. **Start the development server**
   ```bash
   php artisan serve
   ```

8. **Access the application**
   - Web Interface: `http://localhost:8000`
   - API Base URL: `http://localhost:8000/api`

## 🌐 Web Interface Usage

### Dark Mode Toggle
- **Floating Action Button**: Located at bottom-right corner of the screen
- **Easy Access**: Click the moon/sun icon to toggle between light and dark themes
- **Persistent**: Your theme preference is saved in browser's local storage
- **Smooth Transitions**: Animated theme changes with visual feedback
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Auto-Detection**: Respects system theme preference on first visit

### Dashboard
- View all tasks in a card-based layout
- Filter by status (Pending, In Progress, Completed)
- Filter by priority (Low, Medium, High)
- Search by title or description
- Color-coded priority indicators

### Task Management
- **Create**: Click "Add New Task" to create tasks
- **View**: Click "View" to see full task details
- **Edit**: Click "Edit" to modify task information
- **Delete**: Click "Delete" with confirmation dialog

### Task Properties
- **Title**: Required, up to 255 characters
- **Description**: Optional, detailed task information
- **Status**: Pending, In Progress, or Completed
- **Priority**: Low (green), Medium (yellow), High (red)
- **Due Date**: Optional deadline with overdue indicators
- **Assigned User**: Required, select from existing users

### Dark Mode
- **Toggle**: Click the moon/sun icon in the top-right navbar
- **Persistence**: Your theme preference is saved locally
- **Smooth Transitions**: Animated theme switching
- **Complete Coverage**: All UI elements support both light and dark themes
- **GitHub-style**: Dark theme uses GitHub's dark color palette

## 🔌 API Usage

### Base URL
```
http://localhost:8000/api
```

### Key Endpoints
- `GET /tasks` - List all tasks with filtering
- `POST /tasks` - Create new task
- `GET /tasks/{id}` - Get specific task
- `PUT /tasks/{id}` - Update task
- `DELETE /tasks/{id}` - Delete task

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
    "priority": "medium",
    "user_id": 1
  }'
```

**Filter tasks:**
```bash
curl -X GET "http://localhost:8000/api/tasks?status=pending&priority=high"
```

## 📱 Mobile Integration

The API is designed to work seamlessly with Flutter mobile applications:

1. **CORS Enabled**: All necessary headers for cross-origin requests
2. **JSON Format**: Consistent JSON responses
3. **Validation**: Server-side validation with detailed error messages
4. **Pagination**: Built-in pagination for large datasets

See `API_DOCUMENTATION.md` for detailed mobile integration examples.

## 📊 Database Schema

### Tasks Table
- `id` - Primary key
- `title` - Task title (required)
- `description` - Task description (nullable)
- `status` - enum: pending, in_progress, completed
- `priority` - enum: low, medium, high
- `due_date` - Deadline (nullable)
- `user_id` - Foreign key to users table
- `created_at` - Timestamp
- `updated_at` - Timestamp

### Users Table (Laravel default)
- `id` - Primary key
- `name` - User name
- `email` - User email
- `password` - Encrypted password
- `created_at` - Timestamp
- `updated_at` - Timestamp

## 🧪 Sample Data

The system includes seeders that create:
- 6 sample users (including John Doe - john@example.com)
- 25 sample tasks with random data
- Various combinations of status, priority, and due dates

## 🔧 Development

### Key Files Modified/Created
1. **Models**: `app/Models/Task.php`
2. **Controllers**: 
   - `app/Http/Controllers/TaskController.php` (Web)
   - `app/Http/Controllers/Api/TaskController.php` (API)
3. **Views**: `resources/views/tasks/` directory with dark mode support
4. **Layout**: `resources/views/layouts/app.blade.php` with theme toggle
5. **Migrations**: `database/migrations/create_tasks_table.php`
6. **Routes**: `routes/web.php` and `routes/api.php`
7. **Middleware**: `app/Http/Middleware/CorsMiddleware.php`

### Customization
- Modify task statuses/priorities in migration and validation rules
- Add more fields to the Task model as needed
- Customize the UI by editing Blade templates
- Extend API functionality in API controllers

## 🚨 Important Notes

1. **Database**: Make sure MySQL is running and database exists
2. **Environment**: Update `.env` file with correct database credentials
3. **CORS**: API is configured for open CORS (adjust for production)
4. **Validation**: All inputs are validated on both client and server side
5. **Pagination**: Web and API support pagination for performance

## 🤝 Contributing

1. Fork the project
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is open-source and available under the MIT License.
