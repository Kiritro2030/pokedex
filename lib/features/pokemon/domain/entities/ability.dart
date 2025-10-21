import 'package:equatable/equatable.dart';

class Ability extends Equatable {
  final String nombre;

  const Ability({required this.nombre});

  @override
  List<Object> get props => [nombre];
}
