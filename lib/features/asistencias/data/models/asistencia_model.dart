class AsistenciaModel {
  final int id;
  final int sesionId;
  final int estudianteId;
  final String estudianteNombre;
  final String? estudianteUsername;
  final bool asistio;
  final String estado;
  final DateTime registradoEn;
  final DateTime? modificadoEn;
  final String? modificadoPorNombre;

  const AsistenciaModel({
    required this.id,
    required this.sesionId,
    required this.estudianteId,
    required this.estudianteNombre,
    this.estudianteUsername,
    required this.asistio,
    required this.estado,
    required this.registradoEn,
    this.modificadoEn,
    this.modificadoPorNombre,
  });

  factory AsistenciaModel.fromJson(Map<String, dynamic> json) {
    return AsistenciaModel(
      id: json['id'] as int,
      sesionId: json['sesion_id'] as int,
      estudianteId: json['estudiante_id'] as int,
      estudianteNombre: json['estudiante_nombre'] as String,
      estudianteUsername: json['estudiante_username'] as String?,
      asistio: json['asistio'] as bool,
      estado: json['estado'] as String,
      registradoEn: DateTime.parse(json['registrado_en'] as String),
      modificadoEn: json['modificado_en'] != null
          ? DateTime.parse(json['modificado_en'] as String)
          : null,
      modificadoPorNombre: json['modificado_por_nombre'] as String?,
    );
  }

  bool get esJustificado => estado == 'ausente_justificado';
  bool get esPendiente => estado == 'pendiente_revision';
}
