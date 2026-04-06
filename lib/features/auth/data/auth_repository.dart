import 'package:dio/dio.dart';
import '../../../core/services/dio_client.dart';
import '../../../core/services/token_service.dart';
import '../../../shared/models/user_model.dart';
import 'models/login_request.dart';

class AuthRepository {
  final DioClient _client;
  final TokenService _tokenService;

  AuthRepository(this._client, this._tokenService);

  Future<UserModel?> login(String login, String password) async {
    try {
      final request = LoginRequest(login: login, password: password);
      final resp = await _client.api.post('/auth/login', data: request.toJson());

      await _tokenService.saveTokens(
        accessToken: resp.data['access_token'] as String,
        refreshToken: resp.data['refresh_token'] as String,
      );

      return await getCurrentUser();
    } on DioException {
      return null;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final resp = await _client.api.get('/auth/me');
      return UserModel.fromBackendJson(resp.data as Map<String, dynamic>);
    } on DioException {
      return null;
    }
  }

  Future<void> logout() async {
    await _tokenService.clear();
  }
}
