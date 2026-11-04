import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/datos/traducir_error.dart';
import 'package:recetario_utez/dominio/falla_red.dart';
import 'package:recetario_utez/datos/recetas_json.dart';
import 'package:recetario_utez/dominio/receta.dart';

const recetasPorPagina = 10;

class DummyJsonRepositorio implements RecetasRepositorio {
  final Dio dio;
  DummyJsonRepositorio(this.dio);

  Future<List<Receta>> obtener() async {
    try {
      final respuesta = await dio.get<Object?>(
        '/recipes',
        queryParameters: {'_limit': recetasPorPagina},
      );
      final datos = respuesta.data;
      if (datos is! List) throw const RespuestaInvalida();
      return [
        for (final item in datos)
          switch (item) {
            Map<String, dynamic> json => recetaDesdeJson(json),
            _ => throw const RespuestaInvalida(),
          },
      ];
    } on DioException catch (e) {
      throw traducirError(e);
    } on FormatException {
      throw const RespuestaInvalida();
    }
  }

  @override
  Future<PaginaRecetas> buscar({String texto = ''}) async {
    final String path;
    final dynamic queryParameters;
    
    if (texto.trim().isNotEmpty) {
      path = '/recipes/search';
      queryParameters = {'q': texto.trim(), 'limit': recetasPorPagina};
    } else {
      path = '/recipes';
      queryParameters = {'limit': recetasPorPagina};
    }

    try {
      final respuesta = await dio.get<Object?>(
        path,
        queryParameters: queryParameters,
      );
      final datos = respuesta.data;
      if (datos is! Map<String, dynamic>) throw const RespuestaInvalida();

      final pagina = paginaDesdeJson(datos);
      return pagina;
    } on DioException catch (e) {
      throw traducirError(e);
    } on FormatException {
      throw const RespuestaInvalida();
    }
  }
}
