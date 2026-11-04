// lib/dominio/receta.dart
const umbralRapidaMinutos = 30;

enum Dificultad {
  facil('Fácil'),
  media('Media'),
  dificil('Difícil'),
  desconocida('Sin dato');

  const Dificultad(this.etiqueta);
  final String etiqueta;
}

class Receta {
  const Receta({
    required this.id,
    required this.nombre,
    required this.cocina,
    required this.dificultad,
    required this.minutosPreparacion,
    required this.minutosCoccion,
    required this.porciones,
    required this.calificacion,
    this.etiquetas = const [],
    this.ingredientes = const [],
  });

  final int id;
  final String nombre;
  final String cocina;
  final Dificultad dificultad;
  final int minutosPreparacion;
  final int minutosCoccion;
  final int porciones;
  final double calificacion;
  final List<String> etiquetas;
  final List<String> ingredientes;

  int get tiempoTotal {
    return minutosPreparacion + minutosCoccion;
  }

  bool get esRapida {
    if (tiempoTotal > umbralRapidaMinutos) {
      return false;
    }
    return true;
  }
}

class PaginaRecetas {
  const PaginaRecetas({required this.recetas, required this.total});
  final List<Receta> recetas;
  final int total;
}
