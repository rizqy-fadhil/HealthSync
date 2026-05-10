<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\HealthLog;

class HealthLogController extends Controller
{
    public function index()
    {
        return response()->json(HealthLog::orderBy('created_at', 'desc')->get());
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'water_intake' => 'nullable|integer',
            'sleep_duration' => 'nullable|numeric',
            'weight' => 'nullable|numeric',
        ]);

        $log = HealthLog::create($validated);

        return response()->json($log, 201);
    }

    public function show(string $id)
    {
        return response()->json(HealthLog::findOrFail($id));
    }

    public function update(Request $request, string $id)
    {
        //
    }

    public function destroy(string $id)
    {
        //
    }
}
