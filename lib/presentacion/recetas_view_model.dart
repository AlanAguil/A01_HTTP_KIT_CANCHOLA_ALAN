import 'package:flutter/material.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/dominio/receta.dart';

sealed class EstadoRecetas { const EstadoRecetas(); }
final class RecetasInicial extends EstadoRecetas { const RecetasInicial(); }
final class RecetasCargando extends EstadoRecetas { const RecetasCargando(); }
final class RecetasListas extends EstadoRecetas { const RecetasListas(this.recetas, this.total); final List<Receta> recetas; final int total; }
final class RecetasVacias extends EstadoRecetas { const RecetasVacias(this.busqueda); final String busqueda; }
final class RecetasFallidas extends EstadoRecetas { const RecetasFallidas(this.mensaje); final String mensaje; }
class RecetasViewModel extends ChangeNotifier {
 RecetasViewModel(RecetasRepositorio repositorio);
 EstadoRecetas get estado; // empieza en RecetasInicial
 bool get cargando; // derivado del estado
 String get ultimaBusqueda; // el último texto buscado, ya sin espacios
 int get rapidas; // derivado: recetas rápidas del resultado; 0 si no hay
 Future<void> buscar(String texto) { ... }
 Future<void> reintentar() { ... }
}
