import 'package:flutter/material.dart';
import '../../core/theme/neubrutalism_theme.dart';

enum LogType {
  water,
  sleep,
  weight;

  String get label {
    switch (this) {
      case LogType.water:     return 'Water';
      case LogType.sleep:     return 'Sleep';
      case LogType.weight:    return 'Weight';
    }
  }

  String get unit {
    switch (this) {
      case LogType.water:     return 'glasses';
      case LogType.sleep:     return 'hrs';
      case LogType.weight:    return 'kg';
    }
  }

  String get emoji {
    switch (this) {
      case LogType.water:     return '💧';
      case LogType.sleep:     return '😴';
      case LogType.weight:    return '⚖️';
    }
  }

  Color get color {
    switch (this) {
      case LogType.water:     return NeuColors.yellow;
      case LogType.sleep:     return NeuColors.mint;
      case LogType.weight:    return NeuColors.pink;
    }
  }
}

class HealthLog {
  final int? id;
  final int? waterIntake;
  final double? sleepDuration;
  final double? weight;
  final DateTime timestamp;

  HealthLog({
    this.id,
    this.waterIntake,
    this.sleepDuration,
    this.weight,
    required this.timestamp,
  });

  factory HealthLog.fromJson(Map<String, dynamic> json) {
    return HealthLog(
      id: json['id'],
      waterIntake: json['water_intake'],
      sleepDuration: json['sleep_duration'] != null ? (json['sleep_duration'] as num).toDouble() : null,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      timestamp: json['created_at'] != null
          ? DateTime.parse(json['created_at']).toLocal()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'water_intake': waterIntake,
      'sleep_duration': sleepDuration,
      'weight': weight,
    };
  }

  // Helper method to determine the primary type of this log entry
  // and its value for the UI cards.
  LogType get primaryType {
    if (weight != null) return LogType.weight;
    if (sleepDuration != null) return LogType.sleep;
    return LogType.water;
  }

  double get primaryValue {
    if (weight != null) return weight!;
    if (sleepDuration != null) return sleepDuration!;
    if (waterIntake != null) return waterIntake!.toDouble();
    return 0;
  }

  String get formattedValue {
    double value = primaryValue;
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}
