<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\TaskController;

// Public routes for tasks (you can add authentication later)
Route::apiResource('tasks', TaskController::class);
