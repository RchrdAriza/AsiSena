import 'dart:typed_data';

class MedicalExcuse {
  final String id;
  final String studentId;
  final String studentName;
  final DateTime date;
  final String reason;
  final String? notes;
  final Uint8List? imageBytes;
  final String? imageName;
  final String status; // pendiente, aprobada, rechazada

  const MedicalExcuse({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.reason,
    this.notes,
    this.imageBytes,
    this.imageName,
    this.status = 'pendiente',
  });

  MedicalExcuse copyWith({
    String? status,
  }) {
    return MedicalExcuse(
      id: id,
      studentId: studentId,
      studentName: studentName,
      date: date,
      reason: reason,
      notes: notes,
      imageBytes: imageBytes,
      imageName: imageName,
      status: status ?? this.status,
    );
  }
}
