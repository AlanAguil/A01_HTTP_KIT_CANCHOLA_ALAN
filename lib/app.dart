import 'package:flutter/material.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/presentacion/recetas_pagina.dart';
import 'package:recetario_utez/presentacion/recetas_view_model.dart';

class AppRecetario extends StatefulWidget {
  const AppRecetario({super.key, required this.repositorio});

  final RecetasRepositorio repositorio;

  @override
  State<AppRecetario> createState() => _AppRecetarioState();
}

class _AppRecetarioState extends State<AppRecetario> {
  late final RecetasViewModel _vm = RecetasViewModel(widget.repositorio);

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetario UTEZ',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: RecetasPagina(vm: _vm),
    );
  }
}
