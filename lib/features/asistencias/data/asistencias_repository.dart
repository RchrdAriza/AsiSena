import '../../../core/services/dio_client.dart';
import 'models/asistencia_model.dart';

class AsistenciasRepository {
  final DioClient _client;

  AsistenciasRepository(this._client);

  Future<AsistenciaModel> getAsistencia(int asistenciaId) async {
    final resp = await _client.api.get('/asistencias/$asistenciaId');
    return AsistenciaModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> modificarEstado(
    int asistenciaId, {
    required String estadoNuevo,
    String? motivo,
  }) async {
    await _client.api.patch(
      '/asistencias/$asistenciaId/estado',
      data: {'estado_nuevo': estadoNuevo, 'motivo': motivo},
    );
  }

  Future<Map<String, dynamic>> getReporteEstudiante(
    int estudianteId,
    int grupoId,
  ) async {
    final resp = await _client.api.get(
      '/reportes/estudiante/$estudianteId',
      queryParameters: {'grupo_id': grupoId},
    );
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getReporteGrupo(int grupoId) async {
    final resp = await _client.api.get('/reportes/grupo/$grupoId');
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getReporteSesion(int sesionId) async {
    final resp = await _client.api.get('/reportes/sesion/$sesionId');
    return resp.data as Map<String, dynamic>;
  }
}
