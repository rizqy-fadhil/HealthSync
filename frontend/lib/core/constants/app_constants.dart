class AppConstants {
  AppConstants._();

  static const String appName = 'HealthSync';
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  // Shared Preferences / Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';
}
