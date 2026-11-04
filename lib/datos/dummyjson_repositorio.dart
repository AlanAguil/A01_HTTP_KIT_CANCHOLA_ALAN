import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';

const recetasPorPagina = 10;
class DummyJsonRepositorio implements RecetasRepositorio {
 DummyJsonRepositorio(Dio dio);
}