import 'local_storage_service.dart';

class TokenService {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final LocalStorageService _storage;

  TokenService(this._storage);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(_accessKey, accessToken);
    await _storage.write(_refreshKey, refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(_accessKey);
  Future<String?> getRefreshToken() => _storage.read(_refreshKey);

  Future<void> clear() async {
    await _storage.delete(_accessKey);
    await _storage.delete(_refreshKey);
  }
}
