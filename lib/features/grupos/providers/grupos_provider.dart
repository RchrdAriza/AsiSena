import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/auth_provider.dart';
import '../data/grupos_repository.dart';
import '../data/models/grupo_model.dart';
import '../../sesiones/data/sesiones_repository.dart';
import '../../sesiones/data/models/sesion_model.dart';
import '../../asistencias/data/asistencias_repository.dart';

final gruposRepositoryProvider = Provider<GruposRepository>((ref) {
  return GruposRepository(ref.watch(dioClientProvider));
});

final sesionesRepositoryProvider = Provider<SesionesRepository>((ref) {
  return SesionesRepository(ref.watch(dioClientProvider));
});

final asistenciasRepositoryProvider = Provider<AsistenciasRepository>((ref) {
  return AsistenciasRepository(ref.watch(dioClientProvider));
});

final gruposProvider = FutureProvider<List<GrupoModel>>((ref) async {
  return ref.watch(gruposRepositoryProvider).getMisGrupos();
});

final sesionesPorGrupoProvider =
    FutureProvider.family<List<SesionModel>, int>((ref, grupoId) async {
  return ref.watch(sesionesRepositoryProvider).getSesionesDeGrupo(grupoId);
});
