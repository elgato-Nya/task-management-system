@extends('layouts.app')

@section('title', 'User Details')

@section('content')
<div class="row">
    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h5><i class="fas fa-user"></i> User Information</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <strong>Name:</strong>
                    <p class="mb-0">{{ $user->name }}</p>
                </div>
                <div class="mb-3">
                    <strong>Email:</strong>
                    <p class="mb-0">{{ $user->email }}</p>
                </div>
                <div class="mb-3">
                    <strong>Joined:</strong>
                    <p class="mb-0">{{ $user->created_at->format('F j, Y') }}</p>
                </div>
                <div class="mb-3">
                    <strong>Total Tasks:</strong>
                    <p class="mb-0">
                        <span class="badge bg-info">{{ $user->tasks->count() }} tasks</span>
                    </p>
                </div>
                
                <div class="d-grid gap-2">
                    <a href="{{ route('users.edit', $user) }}" class="btn btn-warning">
                        <i class="fas fa-edit"></i> Edit User
                    </a>
                    <a href="{{ route('users.index') }}" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Users
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h5><i class="fas fa-tasks"></i> Assigned Tasks ({{ $user->tasks->count() }})</h5>
            </div>
            <div class="card-body">
                @if($user->tasks->count() > 0)
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th class="text-light">Title</th>
                                    <th class="text-light">Status</th>
                                    <th class="text-light">Priority</th>
                                    <th class="text-light">Due Date</th>
                                    <th class="text-light">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($user->tasks as $task)
                                <tr>
                                    <td>
                                        <strong>{{ $task->title }}</strong>
                                        @if($task->description)
                                            <br><small class="text-body-secondary">{{ Str::limit($task->description, 50) }}</small>
                                        @endif
                                    </td>
                                    <td>
                                        @php
                                            $statusClasses = [
                                                'pending' => 'bg-warning',
                                                'in_progress' => 'bg-info',
                                                'completed' => 'bg-success'
                                            ];
                                        @endphp
                                        <span class="badge {{ $statusClasses[$task->status] ?? 'bg-secondary' }}">
                                            {{ ucfirst(str_replace('_', ' ', $task->status)) }}
                                        </span>
                                    </td>
                                    <td>
                                        @php
                                            $priorityClasses = [
                                                'low' => 'bg-success',
                                                'medium' => 'bg-warning',
                                                'high' => 'bg-danger'
                                            ];
                                        @endphp
                                        <span class="badge {{ $priorityClasses[$task->priority] ?? 'bg-secondary' }}">
                                            {{ ucfirst($task->priority) }}
                                        </span>
                                    </td>
                                    <td>
                                        @if($task->due_date)
                                            <small class="text-body-secondary">
                                                {{ $task->due_date->format('M j, Y') }}
                                                @if($task->due_date->isPast())
                                                    <span class="text-danger">(Overdue)</span>
                                                @endif
                                            </small>
                                        @else
                                            <small class="text-body-secondary">No due date</small>
                                        @endif
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="{{ route('tasks.show', $task) }}" 
                                               class="btn btn-outline-info" title="View Task">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="{{ route('tasks.edit', $task) }}" 
                                               class="btn btn-outline-warning" title="Edit Task">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @else
                    <div class="text-center py-4">
                        <i class="fas fa-tasks fa-2x text-secondary mb-3"></i>
                        <h5 class="text-body-secondary">No Tasks Assigned</h5>
                        <p class="text-body-secondary">This user has no tasks assigned yet.</p>
                        <a href="{{ route('tasks.create') }}" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Assign Task
                        </a>
                    </div>
                @endif
            </div>
        </div>
    </div>
</div>
@endsection
