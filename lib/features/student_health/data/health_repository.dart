import 'dart:typed_data';

import '../../../core/services/dio_client.dart';
import 'models/health_record.dart';
import 'models/attendance_record.dart';
import 'models/medical_excuse.dart';

class HealthRepository {
  final DioClient _client;
  final List<MedicalExcuse> _excuses = [];

  HealthRepository(this._client);

  /// Obtiene el resumen de salud/asistencia del estudiante desde el backend.
  /// [grupoId] es requerido para filtrar el reporte por grupo.
  Future<HealthRecord> getHealthRecord(String studentId, {int? grupoId}) async {
    if (grupoId != null) {
      try {
        final resp = await _client.api.get(
          '/reportes/estudiante/$studentId',
          queryParameters: {'grupo_id': grupoId},
        );
        final data = resp.data as Map<String, dynamic>;
        final pct = (data['porcentaje_asistencia'] as num).toDouble();
        final ausentes = (data['total_ausentes_injustificados'] as int) +
            (data['total_ausentes_justificados'] as int);

        String status;
        if (pct >= 90) {
          status = 'Excelente';
        } else if (pct >= 75) {
          status = 'Bueno';
        } else if (pct >= 60) {
          status = 'En Riesgo';
        } else {
          status = 'Crítico';
        }

        return HealthRecord(
          id: studentId,
          studentId: studentId,
          status: status,
          attendanceRate: pct,
          totalAbsences: ausentes,
          wellbeingReports: 0,
          lastUpdated: DateTime.now(),
        );
      } catch (_) {
        // Si falla la API, devuelve un registro vacío
      }
    }

    return HealthRecord(
      id: studentId,
      studentId: studentId,
      status: 'Sin datos',
      attendanceRate: 0.0,
      totalAbsences: 0,
      wellbeingReports: 0,
      lastUpdated: DateTime.now(),
    );
  }

  /// Obtiene el historial de asistencia desde el endpoint de reportes de grupo.
  Future<List<AttendanceRecord>> getAttendanceHistory(
    String studentId, {
    int? grupoId,
  }) async {
    if (grupoId != null) {
      try {
        final resp = await _client.api.get(
          '/reportes/grupo/$grupoId',
        );
        final data = resp.data as Map<String, dynamic>;
        final sesiones = data['sesiones'] as List;

        return sesiones.map((s) {
          final fecha = DateTime.parse(s['fecha'] as String);
          final pct = (s['porcentaje_asistencia'] as num).toDouble();
          return AttendanceRecord(
            date: fecha,
            present: pct > 50,
            note: s['descripcion'] as String?,
          );
        }).toList();
      } catch (_) {}
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> getWellbeingReports(String studentId) async {
    return [];
  }

  Future<List<MedicalExcuse>> getMedicalExcuses(String studentId) async {
    return _excuses.where((e) => e.studentId == studentId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<MedicalExcuse>> getAllMedicalExcuses() async {
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
    final index = _excuses.indexWhere((e) => e.id == excuseId);
    if (index != -1) {
      _excuses[index] = _excuses[index].copyWith(status: status);
    }
  }
}
