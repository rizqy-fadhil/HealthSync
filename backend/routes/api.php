<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\HealthLogController;

// Auth routes (public)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Auth routes (protected)
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

// User info (protected)
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Health logs (protected — user must be authenticated)
Route::apiResource('health-logs', HealthLogController::class)->middleware('auth:sanctum');
