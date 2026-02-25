import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/auth_provider.dart';
import '../data/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) => ProfileRepository());

class ProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;
  final ProfileRepository _repository;

  ProfileNotifier(this._ref, this._repository) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _ref.read(currentUserProvider);
    if (user != null) {
      state = AsyncValue.data(user);
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.updateProfile(updatedUser);
      _ref.read(currentUserProvider.notifier).state = result;
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserModel?>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(ref, repository);
});
