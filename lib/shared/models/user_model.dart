import 'role.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final Role role;
  final String? phone;
  final String? document;
  final String? program;
  final String? group;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone,
    this.document,
    this.program,
    this.group,
    this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    Role? role,
    String? phone,
    String? document,
    String? program,
    String? group,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      document: document ?? this.document,
      program: program ?? this.program,
      group: group ?? this.group,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role.name,
      'phone': phone,
      'document': document,
      'program': program,
      'group': group,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: Role.values.firstWhere((r) => r.name == json['role']),
      phone: json['phone'] as String?,
      document: json['document'] as String?,
      program: json['program'] as String?,
      group: json['group'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
