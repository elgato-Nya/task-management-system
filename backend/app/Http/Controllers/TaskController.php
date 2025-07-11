<?php

namespace App\Http\Controllers;

use App\Models\Task;
use App\Models\User;
use App\Http\Requests\StoreTaskRequest;
use App\Http\Requests\UpdateTaskRequest;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Task::with('user');
        
        // Filter by status
        if ($request->filled('status')) {
            $query->byStatus($request->status);
        }
        
        // Filter by priority
        if ($request->filled('priority')) {
            $query->byPriority($request->priority);
        }
        
        // Search in title and description
        if ($request->filled('search')) {
            $query->where(function($q) use ($request) {
                $q->where('title', 'like', '%' . $request->search . '%')
                  ->orWhere('description', 'like', '%' . $request->search . '%');
            });
        }
        
        $tasks = $query->latest()->paginate(12);
        
        return view('tasks.index', compact('tasks'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $users = User::orderBy('name')->get();
        return view('tasks.create', compact('users'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreTaskRequest $request)
    {
        $validated = $request->validated();
        
        // Handle user assignment
        if ($request->input('user_assignment_type') === 'new') {
            // Create new user
            $user = User::create([
                'name' => $validated['new_user_name'],
                'email' => $validated['new_user_email'],
                'password' => bcrypt('password'), // Default password, should be changed
            ]);
            
            $validated['user_id'] = $user->id;
        }
        
        // Remove the assignment type and new user fields from validated data
        unset($validated['user_assignment_type'], $validated['new_user_name'], $validated['new_user_email']);
        
        Task::create($validated);

        return redirect()->route('tasks.index')
            ->with('success', 'Task created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(Task $task)
    {
        return view('tasks.show', compact('task'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Task $task)
    {
        $users = User::orderBy('name')->get();
        return view('tasks.edit', compact('task', 'users'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateTaskRequest $request, Task $task)
    {
        $validated = $request->validated();
        
        // Handle user assignment
        if ($request->input('user_assignment_type') === 'new') {
            // Create new user
            $user = User::create([
                'name' => $validated['new_user_name'],
                'email' => $validated['new_user_email'],
                'password' => bcrypt('password'), // Default password, should be changed
            ]);
            
            $validated['user_id'] = $user->id;
        }
        
        // Remove the assignment type and new user fields from validated data
        unset($validated['user_assignment_type'], $validated['new_user_name'], $validated['new_user_email']);
        
        $task->update($validated);

        return redirect()->route('tasks.index')
            ->with('success', 'Task updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Task $task)
    {
        $task->delete();

        return redirect()->route('tasks.index')
            ->with('success', 'Task deleted successfully');
    }
}
