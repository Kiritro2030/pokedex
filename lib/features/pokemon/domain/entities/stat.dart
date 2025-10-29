import 'package:equatable/equatable.dart';

class Stat extends Equatable {
  final String name;
  final int valor;

  const Stat({required this.name, required this.valor});

  @override
  List<Object> get props => [];
}
