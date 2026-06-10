class AppConstants {
  AppConstants._();

  static const String appName = 'HealthSync';
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://healthsync.onrender.com/api',
  );

  // Shared Preferences / Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';
}
