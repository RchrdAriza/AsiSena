import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/health_repository.dart';
import '../data/models/health_record.dart';
import '../data/models/attendance_record.dart';
import '../data/models/medical_excuse.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) => HealthRepository());

final healthRecordProvider = FutureProvider.family<HealthRecord, String>((ref, studentId) {
  return ref.watch(healthRepositoryProvider).getHealthRecord(studentId);
});

final attendanceHistoryProvider = FutureProvider.family<List<AttendanceRecord>, String>((ref, studentId) {
  return ref.watch(healthRepositoryProvider).getAttendanceHistory(studentId);
});

final wellbeingReportsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, studentId) {
  return ref.watch(healthRepositoryProvider).getWellbeingReports(studentId);
});

final medicalExcusesProvider = StateNotifierProvider<MedicalExcusesNotifier, AsyncValue<List<MedicalExcuse>>>((ref) {
  return MedicalExcusesNotifier(ref.watch(healthRepositoryProvider));
});

class MedicalExcusesNotifier extends StateNotifier<AsyncValue<List<MedicalExcuse>>> {
  final HealthRepository _repository;

  MedicalExcusesNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> loadExcuses(String studentId) async {
    state = const AsyncValue.loading();
    try {
      final excuses = await _repository.getMedicalExcuses(studentId);
      state = AsyncValue.data(excuses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadAllExcuses() async {
    state = const AsyncValue.loading();
    try {
      final excuses = await _repository.getAllMedicalExcuses();
      state = AsyncValue.data(excuses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submitExcuse({
    required String studentId,
    required String studentName,
    required String reason,
    String? notes,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    await _repository.submitMedicalExcuse(
      studentId: studentId,
      studentName: studentName,
      reason: reason,
      notes: notes,
      imageBytes: imageBytes,
      imageName: imageName,
    );
    final excuses = await _repository.getMedicalExcuses(studentId);
    state = AsyncValue.data(excuses);
  }

  Future<void> updateStatus(String excuseId, String status, String studentId) async {
    await _repository.updateExcuseStatus(excuseId, status);
    final excuses = await _repository.getAllMedicalExcuses();
    state = AsyncValue.data(excuses);
  }
}
