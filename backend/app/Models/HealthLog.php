<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HealthLog extends Model
{
    protected $fillable = [
        'water_intake',
        'sleep_duration',
        'weight',
    ];
}
