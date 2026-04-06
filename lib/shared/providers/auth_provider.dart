import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../core/services/dio_client.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/token_service.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) => LocalStorageService());

final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService(ref.watch(localStorageProvider));
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(tokenServiceProvider));
});

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});
