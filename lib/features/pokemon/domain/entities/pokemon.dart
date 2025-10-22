import 'package:equatable/equatable.dart';
import 'package:pokedex/features/pokemon/domain/entities/ability.dart';
import 'package:pokedex/features/pokemon/domain/entities/stat.dart';

class Pokemon extends Equatable {
  final int id;
  final String nombre;
  final String imageUrl;
  final List<String> types;
  final List<Stat> stats;
  final List<Ability> abilities;

  const Pokemon({
    required this.id,
    required this.nombre,
    required this.imageUrl,
    required this.types,
    this.stats = const [],
    this.abilities = const [],
  });

  @override
  List<Object> get props => [id, nombre];
}
