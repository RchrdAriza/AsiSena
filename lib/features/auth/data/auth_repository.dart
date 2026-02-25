import '../../../shared/models/user_model.dart';
import '../../../shared/models/role.dart';

class AuthRepository {
  // Mock users for development
  static final List<UserModel> _mockUsers = [
    const UserModel(
      id: '1',
      fullName: 'Carlos Gómez',
      email: 'admin@sena.edu.co',
      role: Role.admin,
      phone: '3001234567',
      document: '1234567890',
    ),
    const UserModel(
      id: '2',
      fullName: 'María López',
      email: 'instructor@sena.edu.co',
      role: Role.instructor,
      phone: '3009876543',
      document: '0987654321',
      program: 'Análisis y Desarrollo de Software',
      group: '2694768',
    ),
    const UserModel(
      id: '3',
      fullName: 'Juan Pérez',
      email: 'aprendiz@sena.edu.co',
      role: Role.apprentice,
      phone: '3005551234',
      document: '1122334455',
      program: 'Análisis y Desarrollo de Software',
      group: '2694768',
    ),
  ];

  Future<UserModel?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      return _mockUsers.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
