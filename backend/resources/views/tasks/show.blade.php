@extends('layouts.app')

@section('title', 'Task Details')

@section('content')
<div class="row justify-content-center">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h4><i class="fas fa-eye"></i> Task Details</h4>
                <div>
                    <span class="badge bg-{{ $task->priority == 'high' ? 'danger' : ($task->priority == 'medium' ? 'warning text-dark' : 'success') }} me-2">
                        {{ ucfirst($task->priority) }} Priority
                    </span>
                    <span class="badge bg-{{ $task->status == 'completed' ? 'success' : ($task->status == 'in_progress' ? 'info' : 'secondary') }}">
                        {{ ucfirst(str_replace('_', ' ', $task->status)) }}
                    </span>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-12">
                        <h2 class="mb-3">{{ $task->title }}</h2>
                        
                        @if($task->description)
                            <div class="mb-4">
                                <h5><i class="fas fa-align-left"></i> Description</h5>
                                <p class="text-muted">{{ $task->description }}</p>
                            </div>
                        @endif

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6><i class="fas fa-user"></i> Assigned To</h6>
                                <p>{{ $task->user->name ?? 'Unassigned' }}</p>
                            </div>
                            <div class="col-md-6">
                                @if($task->due_date)
                                    <h6><i class="fas fa-calendar"></i> Due Date</h6>
                                    <p class="{{ $task->due_date->isPast() && $task->status != 'completed' ? 'text-danger' : '' }}">
                                        {{ $task->due_date->format('F d, Y \a\t h:i A') }}
                                        @if($task->due_date->isPast() && $task->status != 'completed')
                                            <span class="badge bg-danger ms-2">Overdue</span>
                                        @endif
                                    </p>
                                @else
                                    <h6><i class="fas fa-calendar"></i> Due Date</h6>
                                    <p class="text-muted">No due date set</p>
                                @endif
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6><i class="fas fa-clock"></i> Created</h6>
                                <p>{{ $task->created_at->format('F d, Y \a\t h:i A') }}</p>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-edit"></i> Last Updated</h6>
                                <p>{{ $task->updated_at->format('F d, Y \a\t h:i A') }}</p>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="{{ route('tasks.index') }}" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Tasks
                            </a>
                            <div>
                                <a href="{{ route('tasks.edit', $task) }}" class="btn btn-warning me-2">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <form action="{{ route('tasks.destroy', $task) }}" method="POST" class="d-inline" 
                                      onsubmit="return confirm('Are you sure you want to delete this task?')">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
