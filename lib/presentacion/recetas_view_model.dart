import 'package:flutter/foundation.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/dominio/falla_red.dart';
import 'package:recetario_utez/dominio/receta.dart';
import 'package:recetario_utez/presentacion/mensajes.dart';

sealed class EstadoRecetas {
  const EstadoRecetas();
}

final class RecetasInicial extends EstadoRecetas {
  const RecetasInicial();
}

final class RecetasCargando extends EstadoRecetas {
  const RecetasCargando();
}

final class RecetasListas extends EstadoRecetas {
  const RecetasListas(this.recetas, this.total);
  final List<Receta> recetas;
  final int total;
}

final class RecetasVacias extends EstadoRecetas {
  const RecetasVacias(this.busqueda);
  final String busqueda;
}

final class RecetasFallidas extends EstadoRecetas {
  const RecetasFallidas(this.mensaje);
  final String mensaje;
}

class RecetasViewModel extends ChangeNotifier {
  RecetasViewModel(RecetasRepositorio repositorio) : _repositorio = repositorio;

  final RecetasRepositorio _repositorio;
  EstadoRecetas _estado = const RecetasInicial();
  String _ultimaBusqueda = '';
  bool _liberado = false;

  EstadoRecetas get estado => _estado; // empieza en RecetasInicial

  bool get cargando => _estado is RecetasCargando; // derivado del estado

  String get ultimaBusqueda =>
      _ultimaBusqueda; // el último texto buscado,ya sin espacios

  // derivado: recetas rápidas del resultado; 0 si no hay
  int get rapidas {
    final estadoActual = _estado;
    if (estadoActual is! RecetasListas) return 0;

    var contador = 0;
    for (final receta in estadoActual.recetas) {
      if (receta.esRapida) contador++;
    }
    return contador;
  }

  Future<void> buscar(String texto) async {
    if (cargando) return;
    _ultimaBusqueda = texto.trim();
    _cambiar(const RecetasCargando());
    try {
      final pagina = await _repositorio.buscar(texto: _ultimaBusqueda);
      _cambiar(
        pagina.recetas.isEmpty
            ? RecetasVacias(_ultimaBusqueda)
            : RecetasListas(pagina.recetas, pagina.total),
      );
    } on FallaRed catch (falla) {
      _cambiar(RecetasFallidas(mensajePara(falla)));
    } catch (_) {
      _cambiar(const RecetasFallidas(mensajeInesperado));
    }
  }

  Future<void> reintentar() {
    return buscar(_ultimaBusqueda);
  }

  void _cambiar(EstadoRecetas nuevo) {
    _estado = nuevo;
    if (!_liberado) notifyListeners();
  }

  @override
  void dispose() {
    _liberado = true;
    super.dispose();
  }
}
