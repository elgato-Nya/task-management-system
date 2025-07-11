<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\TaskController;
use App\Http\Controllers\Api\UserController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Public routes for tasks (you can add authentication later)
Route::apiResource('tasks', TaskController::class);

// Public routes for users (you can add authentication later)
Route::apiResource('users', UserController::class);
