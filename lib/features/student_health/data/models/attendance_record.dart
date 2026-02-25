class AttendanceRecord {
  final DateTime date;
  final bool present;
  final String? note;

  const AttendanceRecord({
    required this.date,
    required this.present,
    this.note,
  });
}
