@extends('layouts.app')

@section('title', 'Create Task')

@section('content')
<div class="row justify-content-center">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-plus"></i> Create New Task</h4>
            </div>
            <div class="card-body">
                <form action="{{ route('tasks.store') }}" method="POST">
                    @csrf
                    
                    <div class="mb-3">
                        <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                        <input type="text" class="form-control @error('title') is-invalid @enderror" 
                               id="title" name="title" value="{{ old('title') }}" required>
                        @error('title')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control @error('description') is-invalid @enderror" 
                                  id="description" name="description" rows="4">{{ old('description') }}</textarea>
                        @error('description')
                            <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                <select class="form-select @error('status') is-invalid @enderror" 
                                        id="status" name="status" required>
                                    <option value="">Select Status</option>
                                    <option value="pending" {{ old('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                                    <option value="in_progress" {{ old('status') == 'in_progress' ? 'selected' : '' }}>In Progress</option>
                                    <option value="completed" {{ old('status') == 'completed' ? 'selected' : '' }}>Completed</option>
                                </select>
                                @error('status')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="priority" class="form-label">Priority <span class="text-danger">*</span></label>
                                <select class="form-select @error('priority') is-invalid @enderror" 
                                        id="priority" name="priority" required>
                                    <option value="">Select Priority</option>
                                    <option value="low" {{ old('priority') == 'low' ? 'selected' : '' }}>Low</option>
                                    <option value="medium" {{ old('priority') == 'medium' ? 'selected' : '' }}>Medium</option>
                                    <option value="high" {{ old('priority') == 'high' ? 'selected' : '' }}>High</option>
                                </select>
                                @error('priority')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="due_date" class="form-label">Due Date</label>
                                <input type="datetime-local" class="form-control @error('due_date') is-invalid @enderror" 
                                       id="due_date" name="due_date" value="{{ old('due_date') }}">
                                @error('due_date')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="user_assignment_type" class="form-label">User Assignment <span class="text-danger">*</span></label>
                                <div class="mb-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="user_assignment_type" 
                                               id="existing_user" value="existing" checked onchange="toggleUserInput()">
                                        <label class="form-check-label" for="existing_user">
                                            Select Existing User
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="user_assignment_type" 
                                               id="new_user" value="new" onchange="toggleUserInput()">
                                        <label class="form-check-label" for="new_user">
                                            Add New User
                                        </label>
                                    </div>
                                </div>
                                
                                <!-- Existing User Selection -->
                                <div id="existing_user_section">
                                    <select class="form-select @error('user_id') is-invalid @enderror" 
                                            id="user_id" name="user_id">
                                        <option value="">Select User</option>
                                        @foreach(\App\Models\User::orderBy('name')->get() as $user)
                                            <option value="{{ $user->id }}" {{ old('user_id') == $user->id ? 'selected' : '' }}>
                                                {{ $user->name }} ({{ $user->email }})
                                            </option>
                                        @endforeach
                                    </select>
                                    @error('user_id')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                                
                                <!-- New User Input -->
                                <div id="new_user_section" style="display: none;">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <input type="text" class="form-control @error('new_user_name') is-invalid @enderror" 
                                                   id="new_user_name" name="new_user_name" placeholder="User Name" value="{{ old('new_user_name') }}">
                                            @error('new_user_name')
                                                <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>
                                        <div class="col-md-6">
                                            <input type="email" class="form-control @error('new_user_email') is-invalid @enderror" 
                                                   id="new_user_email" name="new_user_email" placeholder="User Email" value="{{ old('new_user_email') }}">
                                            @error('new_user_email')
                                                <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="{{ route('tasks.index') }}" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Tasks
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Create Task
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function toggleUserInput() {
    const existingUserRadio = document.getElementById('existing_user');
    const newUserRadio = document.getElementById('new_user');
    const existingUserSection = document.getElementById('existing_user_section');
    const newUserSection = document.getElementById('new_user_section');
    const userSelect = document.getElementById('user_id');
    const newUserName = document.getElementById('new_user_name');
    const newUserEmail = document.getElementById('new_user_email');
    
    if (existingUserRadio.checked) {
        existingUserSection.style.display = 'block';
        newUserSection.style.display = 'none';
        userSelect.required = true;
        newUserName.required = false;
        newUserEmail.required = false;
        // Clear new user fields
        newUserName.value = '';
        newUserEmail.value = '';
    } else if (newUserRadio.checked) {
        existingUserSection.style.display = 'none';
        newUserSection.style.display = 'block';
        userSelect.required = false;
        newUserName.required = true;
        newUserEmail.required = true;
        // Clear existing user selection
        userSelect.value = '';
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    toggleUserInput();
});
</script>
@endsection
