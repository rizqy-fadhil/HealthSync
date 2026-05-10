import '../models/user_model.dart';

/// Abstract contract for auth operations.
/// Implementations live in [datasources].
abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}
