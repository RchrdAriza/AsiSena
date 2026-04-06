import '../../../core/services/dio_client.dart';
import 'models/grupo_model.dart';

class GruposRepository {
  final DioClient _client;

  GruposRepository(this._client);

  Future<List<GrupoModel>> getMisGrupos() async {
    final resp = await _client.api.get('/grupos');
    return (resp.data as List)
        .map((e) => GrupoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GrupoModel> getGrupo(int id) async {
    final resp = await _client.api.get('/grupos/$id');
    return GrupoModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
