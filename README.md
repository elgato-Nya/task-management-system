# Personal Task Management System

A clean and simple personal task management system built with **Laravel** backend and **Flutter** mobile app. This system helps you organize and track your tasks efficiently with a modern, intuitive interface.

## 🎯 Overview

This is a **personal task manager** designed for individual use - no complex user management or multi-user features. Just you and your tasks, beautifully organized.

### 🔧 Technology Stack
- **Backend**: Laravel 11 (PHP) with MySQL database
- **Mobile App**: Flutter with Material 3 design
- **API**: RESTful API communication between mobile and backend
- **Web Interface**: Laravel Blade templates with Bootstrap 5

## ✨ Key Features

### 📱 Mobile App (Flutter)
- **Task Management**: Create, edit, delete, and view tasks
- **Smart Filtering**: Filter by status (pending, in progress, completed) and priority (low, medium, high)
- **Search**: Quick search through task titles and descriptions
- **Due Dates**: Set and track task deadlines
- **Theme Support**: Light, dark, and system theme modes with persistence
- **Material 3 Design**: Modern, clean interface following Material Design guidelines
- **Offline-Ready**: Local state management with API synchronization

### 🛠️ Backend API (Laravel)
- **RESTful API**: Clean REST endpoints for all task operations
- **Data Validation**: Server-side validation for all inputs
- **Pagination**: Efficient handling of large task lists
- **JSON Responses**: Structured, consistent API responses
- **Database Management**: MySQL with migrations and seeders
- **Web Interface**: Alternative web-based task management

### 🗄️ Database
- **Task Storage**: Comprehensive task data with status, priority, due dates
- **Migration System**: Version-controlled database schema
- **Sample Data**: Automated seeding for testing and development

## � Project Structure

```
task-management-system/
├── backend/           # Laravel API and web interface
├── mobile/           # Flutter mobile application
└── README.md         # This file
```

## 🚀 Quick Start

1. **Setup Backend**: Navigate to `backend/` folder and follow setup instructions
2. **Setup Mobile**: Navigate to `mobile/` folder and follow setup instructions
3. **Configure Connection**: Update API endpoints in mobile app configuration
4. **Run**: Start Laravel server and launch Flutter app

## 📊 Current Status

✅ **Fully Functional Personal Task Manager**
- Complete CRUD operations for tasks
- Mobile app with beautiful UI
- API communication working
- Database properly configured
- All user-related complexity removed for simplicity

---

*This project was transformed from a complex multi-user system to a simple, efficient personal task manager - because sometimes simpler is better.*
