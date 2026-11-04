import 'package:recetario_utez/dominio/receta.dart';

Dificultad dificultadDesdeTexto(Object? valor) {
  return switch (valor) {
    'Easy' => Dificultad.facil,
    'Medium' => Dificultad.media,
    'Hard' => Dificultad.dificil,
    _ => Dificultad.desconocida,
  };
}

List<String> _listaTextosOpcional(Map<String, dynamic> json, String llave) {
  final valor = json[llave];
  if (valor == null) return const [];
  if (valor is! List) {
    throw FormatException('"$llave" debe ser una lista', valor);
  }
  final resultado = <String>[];
  for (final elemento in valor) {
    if (elemento is! String) {
      throw FormatException('"$llave" solo admite textos', elemento);
    }
    resultado.add(elemento);
  }
  return resultado;
}

Receta recetaDesdeJson(Map<String, dynamic> json) {
  switch (json) {
    case {
      'id': int id,
      'name': String nombre,
      'cuisine': String cocina,
      'prepTimeMinutes': int preparacion,
      'cookTimeMinutes': int coccion,
      'servings': int porciones,
      'rating': num calificacion,
    }:
      return Receta(
        id: id,
        nombre: nombre,
        cocina: cocina,
        dificultad: dificultadDesdeTexto(json['difficulty']),
        minutosPreparacion: preparacion,
        minutosCoccion: coccion,
        porciones: porciones,
        calificacion: calificacion.toDouble(),
        etiquetas: _listaTextosOpcional(json, 'tags'),
        ingredientes: _listaTextosOpcional(json, 'ingredients'),
      );
    default:
      throw FormatException(
        'Receta con campos faltantes o de tipo incorrecto',
        json,
      );
  }
}

PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  switch (json) {
    case {
        'recipes': List lista, 
        'total': int total
      }:
      final recetas = <Receta>[];
      for (final elemento in lista) {
        if (elemento is! Map<String, dynamic>) {
          throw FormatException('Cada receta debe ser un objeto', elemento);
        }
        recetas.add(recetaDesdeJson(elemento));
      }
      return PaginaRecetas(recetas: recetas, total: total);
    default:
      throw FormatException('Página sin "recipes" o "total" válidos', json);
  }
}
