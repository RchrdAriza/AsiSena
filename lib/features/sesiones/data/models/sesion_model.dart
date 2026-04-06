class SesionModel {
  final int id;
  final int grupoId;
  final String? descripcion;
  final bool automatica;
  final bool activa;
  final DateTime abiertaEn;
  final DateTime? cerradaEn;
  final int? creadaPor;
  final int totalAsistencias;
  final int totalAusentes;
  final int totalPendientes;

  const SesionModel({
    required this.id,
    required this.grupoId,
    this.descripcion,
    required this.automatica,
    required this.activa,
    required this.abiertaEn,
    this.cerradaEn,
    this.creadaPor,
    this.totalAsistencias = 0,
    this.totalAusentes = 0,
    this.totalPendientes = 0,
  });

  factory SesionModel.fromJson(Map<String, dynamic> json) {
    return SesionModel(
      id: json['id'] as int,
      grupoId: json['grupo_id'] as int,
      descripcion: json['descripcion'] as String?,
      automatica: json['automatica'] as bool,
      activa: json['activa'] as bool,
      abiertaEn: DateTime.parse(json['abierta_en'] as String),
      cerradaEn: json['cerrada_en'] != null
          ? DateTime.parse(json['cerrada_en'] as String)
          : null,
      creadaPor: json['creada_por'] as int?,
      totalAsistencias: json['total_asistencias'] as int? ?? 0,
      totalAusentes: json['total_ausentes'] as int? ?? 0,
      totalPendientes: json['total_pendientes'] as int? ?? 0,
    );
  }
}
