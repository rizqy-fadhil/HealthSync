<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\HealthLog;

class HealthLogController extends Controller
{
    /**
     * Display a listing of the authenticated user's health logs.
     */
    public function index(Request $request)
    {
        return response()->json(
            $request->user()->healthLogs()->orderBy('created_at', 'desc')->get()
        );
    }

    /**
     * Store a newly created health log for the authenticated user.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'water_intake' => 'nullable|integer|min:1',
            'sleep_duration' => 'nullable|numeric|min:0.1',
            'weight' => 'nullable|numeric|min:0.1',
        ]);

        $log = $request->user()->healthLogs()->create($validated);

        return response()->json($log, 201);
    }

    /**
     * Display the specified health log (only if it belongs to the user).
     */
    public function show(Request $request, string $id)
    {
        $log = $request->user()->healthLogs()->findOrFail($id);
        return response()->json($log);
    }

    /**
     * Update the specified health log.
     */
    public function update(Request $request, string $id)
    {
        $log = $request->user()->healthLogs()->findOrFail($id);

        $validated = $request->validate([
            'water_intake' => 'nullable|integer|min:1',
            'sleep_duration' => 'nullable|numeric|min:0.1',
            'weight' => 'nullable|numeric|min:0.1',
        ]);

        $log->update($validated);
        return response()->json($log);
    }

    /**
     * Remove the specified health log.
     */
    public function destroy(Request $request, string $id)
    {
        $log = $request->user()->healthLogs()->findOrFail($id);
        $log->delete();

        return response()->json(['message' => 'Deleted.'], 200);
    }
}
