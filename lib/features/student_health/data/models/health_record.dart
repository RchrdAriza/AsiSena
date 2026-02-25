class HealthRecord {
  final String id;
  final String studentId;
  final String status; // Excelente, Bueno, En Riesgo, Crítico
  final double attendanceRate;
  final int totalAbsences;
  final int wellbeingReports;
  final DateTime lastUpdated;

  const HealthRecord({
    required this.id,
    required this.studentId,
    required this.status,
    required this.attendanceRate,
    required this.totalAbsences,
    required this.wellbeingReports,
    required this.lastUpdated,
  });
}
