import '../../../core/services/dio_client.dart';
import 'models/sesion_model.dart';
import '../../asistencias/data/models/asistencia_model.dart';

class SesionesRepository {
  final DioClient _client;

  SesionesRepository(this._client);

  Future<List<SesionModel>> getSesionesDeGrupo(int grupoId) async {
    final resp = await _client.api.get('/grupos/$grupoId/sesiones');
    return (resp.data as List)
        .map((e) => SesionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SesionModel> getSesion(int sesionId) async {
    final resp = await _client.api.get('/sesiones/$sesionId');
    return SesionModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<SesionModel> crearSesion(int grupoId, {String? descripcion}) async {
    final resp = await _client.api.post(
      '/grupos/$grupoId/sesiones',
      data: {'descripcion': descripcion},
    );
    return SesionModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<SesionModel> cerrarSesion(int sesionId) async {
    final resp = await _client.api.patch('/sesiones/$sesionId/cerrar');
    return SesionModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<AsistenciaModel>> getAsistencias(int sesionId) async {
    final resp = await _client.api.get('/sesiones/$sesionId/asistencias');
    return (resp.data as List)
        .map((e) => AsistenciaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
