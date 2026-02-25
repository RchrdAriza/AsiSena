import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardStats {
  final int totalStudents;
  final int totalInstructors;
  final int activePrograms;
  final double attendanceRate;
  final List<String> recentActivity;

  const DashboardStats({
    required this.totalStudents,
    required this.totalInstructors,
    required this.activePrograms,
    required this.attendanceRate,
    required this.recentActivity,
  });
}

class InstructorStats {
  final int totalGroups;
  final int totalStudents;
  final double attendanceRate;
  final List<Map<String, String>> upcomingClasses;
  final List<String> recentActivity;

  const InstructorStats({
    required this.totalGroups,
    required this.totalStudents,
    required this.attendanceRate,
    required this.upcomingClasses,
    required this.recentActivity,
  });
}

class ApprenticeStats {
  final double attendanceRate;
  final String healthStatus;
  final String currentProgram;
  final String group;
  final List<Map<String, String>> upcomingClasses;
  final List<String> recentGrades;

  const ApprenticeStats({
    required this.attendanceRate,
    required this.healthStatus,
    required this.currentProgram,
    required this.group,
    required this.upcomingClasses,
    required this.recentGrades,
  });
}

final adminDashboardProvider = FutureProvider<DashboardStats>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return const DashboardStats(
    totalStudents: 1247,
    totalInstructors: 86,
    activePrograms: 32,
    attendanceRate: 87.5,
    recentActivity: [
      'Nuevo aprendiz registrado en ADSO',
      'Reporte de bienestar generado',
      'Instructor María López actualizó horario',
      'Programa TIC actualizado',
      '3 aprendices marcados en riesgo',
    ],
  );
});

final instructorDashboardProvider = FutureProvider<InstructorStats>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return const InstructorStats(
    totalGroups: 4,
    totalStudents: 120,
    attendanceRate: 91.2,
    upcomingClasses: [
      {'subject': 'Programación Web', 'time': '8:00 AM', 'group': '2694768'},
      {'subject': 'Base de Datos', 'time': '10:00 AM', 'group': '2694770'},
      {'subject': 'Redes', 'time': '2:00 PM', 'group': '2694772'},
    ],
    recentActivity: [
      'Asistencia registrada - Ficha 2694768',
      'Notas publicadas - Programación Web',
      'Reporte enviado a coordinación',
    ],
  );
});

final apprenticeDashboardProvider = FutureProvider<ApprenticeStats>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return const ApprenticeStats(
    attendanceRate: 94.0,
    healthStatus: 'Bueno',
    currentProgram: 'Análisis y Desarrollo de Software',
    group: '2694768',
    upcomingClasses: [
      {'subject': 'Programación Web', 'time': '8:00 AM', 'instructor': 'María López'},
      {'subject': 'Base de Datos', 'time': '10:00 AM', 'instructor': 'Pedro Martínez'},
      {'subject': 'Inglés', 'time': '2:00 PM', 'instructor': 'Ana García'},
    ],
    recentGrades: [
      'Programación Web: 4.5',
      'Base de Datos: 4.2',
      'Redes: 3.8',
    ],
  );
});
