import 'package:recetario_utez/dominio/receta.dart';

abstract class RecetasRepositorio {
 Future<PaginaRecetas> buscar({String texto = ''});
}