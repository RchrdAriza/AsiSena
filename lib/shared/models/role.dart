enum Role {
  admin,
  instructor,
  apprentice;

  String get displayName {
    switch (this) {
      case Role.admin:
        return 'Administrativo';
      case Role.instructor:
        return 'Instructor';
      case Role.apprentice:
        return 'Aprendiz';
    }
  }
}
