import 'dart:typed_data';

import 'models/health_record.dart';
import 'models/attendance_record.dart';
import 'models/medical_excuse.dart';

class HealthRepository {
  final List<MedicalExcuse> _excuses = [];


  Future<HealthRecord> getHealthRecord(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return HealthRecord(
      id: '1',
      studentId: studentId,
      status: 'Bueno',
      attendanceRate: 94.0,
      totalAbsences: 3,
      wellbeingReports: 1,
      lastUpdated: DateTime.now(),
    );
  }

  Future<List<AttendanceRecord>> getAttendanceHistory(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return List.generate(30, (i) {
      final date = now.subtract(Duration(days: 30 - i));
      final isWeekend = date.weekday == 6 || date.weekday == 7;
      return AttendanceRecord(
        date: date,
        present: isWeekend ? true : (i % 7 != 3),
        note: i % 7 == 3 ? 'Excusa médica' : null,
      );
    });
  }

  Future<List<Map<String, dynamic>>> getWellbeingReports(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'type': 'Psicología',
        'notes': 'Seguimiento rutinario - Sin novedades',
        'status': 'Cerrado',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 45)),
        'type': 'Enfermería',
        'notes': 'Consulta por dolor de cabeza',
        'status': 'Cerrado',
      },
    ];
  }

  Future<List<MedicalExcuse>> getMedicalExcuses(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _excuses.where((e) => e.studentId == studentId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<MedicalExcuse>> getAllMedicalExcuses() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_excuses)..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<MedicalExcuse> submitMedicalExcuse({
    required String studentId,
    required String studentName,
    required String reason,
    String? notes,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final excuse = MedicalExcuse(
      id: 'exc_${DateTime.now().millisecondsSinceEpoch}',
      studentId: studentId,
      studentName: studentName,
      date: DateTime.now(),
      reason: reason,
      notes: notes,
      imageBytes: imageBytes,
      imageName: imageName,
    );
    _excuses.add(excuse);
    return excuse;
  }

  Future<void> updateExcuseStatus(String excuseId, String status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _excuses.indexWhere((e) => e.id == excuseId);
    if (index != -1) {
      _excuses[index] = _excuses[index].copyWith(status: status);
    }
  }
}
