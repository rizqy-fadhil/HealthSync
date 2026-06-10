import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Centralized authentication service.
/// Handles login, register, logout, and token persistence via SharedPreferences.
class AuthService {
  AuthService._();

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  // ─── Token Persistence ────────────────────────

  /// Save the auth token and user JSON to local storage.
  static Future<void> saveAuthData({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, jsonEncode(user));
  }

  /// Retrieve the stored auth token, or null if not found.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  /// Retrieve the stored user data, or null if not found.
  static Future<Map<String, dynamic>?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.userKey);
    if (raw == null) return null;
    return _castMap(jsonDecode(raw));
  }

  /// Check if the user is currently logged in.
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all auth data (logout).
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }

  // ─── API Calls ────────────────────────────────

  /// Safely cast Dio's decoded JSON to Map<String, dynamic>.
  /// Dio returns Map<dynamic, dynamic> for nested objects,
  /// which causes a _TypeError when cast with `as Map<String, dynamic>`.
  static Map<String, dynamic> _castMap(dynamic data) {
    return Map<String, dynamic>.from(data as Map);
  }

  /// POST /api/register
  /// Returns `{user, token}` on success.
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });

    final data = _castMap(response.data);
    await saveAuthData(
      token: data['token'] as String,
      user: _castMap(data['user']),
    );
    return data;
  }

  /// POST /api/login
  /// Returns `{user, token}` on success.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    final data = _castMap(response.data);
    await saveAuthData(
      token: data['token'] as String,
      user: _castMap(data['user']),
    );
    return data;
  }

  /// POST /api/logout (requires auth token in header).
  static Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await _dio.post(
          '/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      } catch (_) {
        // Even if the API call fails, we still clear local data
      }
    }
    await clearAuthData();
  }
}
