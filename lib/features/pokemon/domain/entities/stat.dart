import 'package:equatable/equatable.dart';

class Stat extends Equatable {
  final String nombre;
  final int valor;

  const Stat({required this.nombre, required this.valor});

  @override
  List<Object> get props => [];
}
