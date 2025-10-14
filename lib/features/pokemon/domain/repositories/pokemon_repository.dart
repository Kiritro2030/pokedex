import 'package:dartz/dartz.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemons({
    required int limit,
    int offset = 0,
  });
}
