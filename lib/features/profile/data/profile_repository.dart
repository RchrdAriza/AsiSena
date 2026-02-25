import '../../../shared/models/user_model.dart';
import '../../../shared/models/role.dart';

class ProfileRepository {
  Future<UserModel> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Returns the current user data (mock)
    return const UserModel(
      id: '3',
      fullName: 'Juan Pérez',
      email: 'aprendiz@sena.edu.co',
      role: Role.apprentice,
      phone: '3005551234',
      document: '1122334455',
      program: 'Análisis y Desarrollo de Software',
      group: '2694768',
    );
  }

  Future<UserModel> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }
}
