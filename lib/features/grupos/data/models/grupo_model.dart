class GrupoModel {
  final int id;
  final int telegramChatId;
  final String nombre;
  final String? materia;
  final bool activo;
  final DateTime creadoEn;

  const GrupoModel({
    required this.id,
    required this.telegramChatId,
    required this.nombre,
    this.materia,
    required this.activo,
    required this.creadoEn,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    return GrupoModel(
      id: json['id'] as int,
      telegramChatId: json['telegram_chat_id'] as int,
      nombre: json['nombre'] as String,
      materia: json['materia'] as String?,
      activo: json['activo'] as bool,
      creadoEn: DateTime.parse(json['creado_en'] as String),
    );
  }
}
