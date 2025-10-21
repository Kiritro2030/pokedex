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
    required this.stats,
    required this.abilities,
  });

  @override
  List<Object> get props => [id, nombre, imageUrl, types];
}
