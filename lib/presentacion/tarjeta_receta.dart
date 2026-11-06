import 'package:flutter/material.dart';
import 'package:recetario_utez/dominio/receta.dart';

class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(receta.nombre, style: tema.textTheme.titleMedium),
                ),
                if (receta.esRapida) const Chip(label: Text('Rápida')),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${receta.cocina} · ${receta.dificultad.etiqueta}',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tiempo: ${receta.tiempoTotal} min · '
              'Porciones: ${receta.porciones}',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Calificación: ${receta.calificacion.toStringAsFixed(1)}',
              style: tema.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
