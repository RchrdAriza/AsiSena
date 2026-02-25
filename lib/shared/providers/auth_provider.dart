import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../core/services/dio_client.dart';
import '../../core/services/local_storage_service.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final localStorageProvider = Provider<LocalStorageService>((ref) => LocalStorageService());

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});
