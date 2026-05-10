import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Concrete implementation talking to the Laravel API.
class AuthRemoteDatasource implements AuthRepository {
  // final ApiClient _client;
  // AuthRemoteDatasource(this._client);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // TODO: POST /api/auth/login
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // TODO: POST /api/auth/register
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: POST /api/auth/logout
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // TODO: GET /api/auth/me
    throw UnimplementedError();
  }
}
