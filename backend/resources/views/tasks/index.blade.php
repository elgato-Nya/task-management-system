@extends('layouts.app')

@section('title', 'Tasks')

@section('content')
<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-tasks"></i> Tasks</h1>
            <div>
                <a href="{{ route('users.index') }}" class="btn btn-outline-secondary me-2">
                    <i class="fas fa-users"></i> Manage Users
                </a>
                <a href="{{ route('tasks.create') }}" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Task
                </a>
            </div>
        </div>

        <!-- Filters -->
        <div class="card mb-4">
            <div class="card-body">
                <form method="GET" action="{{ route('tasks.index') }}" class="row g-3">
                    <div class="col-md-3">
                        <label for="status" class="form-label">Status</label>
                        <select name="status" id="status" class="form-select">
                            <option value="">All Statuses</option>
                            <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                            <option value="in_progress" {{ request('status') == 'in_progress' ? 'selected' : '' }}>In Progress</option>
                            <option value="completed" {{ request('status') == 'completed' ? 'selected' : '' }}>Completed</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="priority" class="form-label">Priority</label>
                        <select name="priority" id="priority" class="form-select">
                            <option value="">All Priorities</option>
                            <option value="low" {{ request('priority') == 'low' ? 'selected' : '' }}>Low</option>
                            <option value="medium" {{ request('priority') == 'medium' ? 'selected' : '' }}>Medium</option>
                            <option value="high" {{ request('priority') == 'high' ? 'selected' : '' }}>High</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="search" class="form-label">Search</label>
                        <input type="text" name="search" id="search" class="form-control" 
                               placeholder="Search in title or description..." value="{{ request('search') }}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-outline-primary">Filter</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        @if($tasks->count() > 0)
            <div class="row">
                @foreach($tasks as $task)
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card task-card priority-{{ $task->priority }} h-100">
                            <div class="card-header status-{{ $task->status }} d-flex justify-content-between align-items-center">
                                <span class="badge bg-secondary">{{ ucfirst(str_replace('_', ' ', $task->status)) }}</span>
                                <span class="badge bg-{{ $task->priority == 'high' ? 'danger' : ($task->priority == 'medium' ? 'warning' : 'success') }}">
                                    {{ ucfirst($task->priority) }}
                                </span>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">{{ $task->title }}</h5>
                                <p class="card-text">{{ Str::limit($task->description, 100) }}</p>
                                @if($task->due_date)
                                    <p class="card-text">
                                        <small class="text-body-secondary">
                                            <i class="fas fa-calendar"></i> Due: {{ $task->due_date->format('M d, Y') }}
                                        </small>
                                    </p>
                                @endif
                                @if($task->user)
                                    <p class="card-text">
                                        <small class="text-body-secondary">
                                            <i class="fas fa-user"></i> Assigned to: {{ $task->user->name }}
                                        </small>
                                    </p>
                                @endif
                            </div>
                            <div class="card-footer">
                                <div class="d-flex gap-2" role="group">
                                    <a href="{{ route('tasks.show', $task) }}" class="btn btn-outline-info btn-sm flex-fill">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <a href="{{ route('tasks.edit', $task) }}" class="btn btn-outline-warning btn-sm flex-fill">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <form action="{{ route('tasks.destroy', $task) }}" method="POST" class="flex-fill" 
                                          onsubmit="return confirm('Are you sure you want to delete this task?')">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-outline-danger btn-sm w-100">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>

            <!-- Enhanced Pagination -->
            <div class="mt-4">
                {{ $tasks->appends(request()->query())->links('pagination::bootstrap-5-enhanced') }}
            </div>
        @else
            <div class="text-center py-5">
                <i class="fas fa-tasks fa-5x text-secondary mb-3"></i>
                <h3 class="text-body-secondary">No tasks found</h3>
                <p class="text-body-secondary">Get started by creating your first task!</p>
                <a href="{{ route('tasks.create') }}" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Create Task
                </a>
            </div>
        @endif
    </div>
</div>
@endsection
