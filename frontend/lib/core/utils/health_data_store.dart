import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../../data/models/health_log.dart';

class HealthDataStore {
  HealthDataStore._();

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  static List<HealthLog> _logs = [];

  static List<HealthLog> get logs => List.unmodifiable(_logs);

  static Future<void> fetchLogs() async {
    try {
      final response = await _dio.get('/health-logs');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _logs = data.map((json) => HealthLog.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching logs: $e');
    }
  }

  static Future<void> addLog(HealthLog log) async {
    try {
      final response = await _dio.post('/health-logs', data: log.toJson());
      if (response.statusCode == 201) {
        _logs.insert(0, HealthLog.fromJson(response.data));
      }
    } catch (e) {
      print('Error adding log: $e');
    }
  }

  /// Latest value for a given type, or 0.
  static double latestValue(LogType type) {
    try {
      return _logs.firstWhere((l) => l.primaryType == type).primaryValue;
    } catch (_) {
      return 0;
    }
  }

  /// Total water intake (glasses) logged today.
  static int todayTotalWater() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return _logs
        .where((l) =>
            l.primaryType == LogType.water &&
            l.timestamp.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
            l.timestamp.isBefore(todayEnd))
        .fold(0, (sum, l) => sum + (l.waterIntake ?? 0));
  }

  /// Total sleep duration (hrs) logged today.
  static double todayTotalSleep() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return _logs
        .where((l) =>
            l.primaryType == LogType.sleep &&
            l.timestamp.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
            l.timestamp.isBefore(todayEnd))
        .fold(0.0, (sum, l) => sum + (l.sleepDuration ?? 0.0));
  }
}
