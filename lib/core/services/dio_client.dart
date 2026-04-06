import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'token_service.dart';

class DioClient {
  late final Dio _dio;
  late final Dio _ollamaDio;
  final TokenService _tokenService;

  DioClient(this._tokenService) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _tryRefresh();
          if (refreshed) {
            final opts = error.requestOptions;
            final token = await _tokenService.getAccessToken();
            opts.headers['Authorization'] = 'Bearer $token';
            try {
              final response = await _dio.fetch(opts);
              handler.resolve(response);
              return;
            } catch (_) {}
          }
        }
        handler.next(error);
      },
    ));

    _ollamaDio = Dio(BaseOptions(
      baseUrl: ApiConstants.ollamaBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 120),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final resp = await Dio().post(
        '${ApiConstants.apiBaseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      await _tokenService.saveTokens(
        accessToken: resp.data['access_token'] as String,
        refreshToken: resp.data['refresh_token'] as String,
      );
      return true;
    } catch (_) {
      await _tokenService.clear();
      return false;
    }
  }

  Dio get api => _dio;
  Dio get ollama => _ollamaDio;
}
