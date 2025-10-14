import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class GetPokemons implements Usecase<List<Pokemon>, GetPokemonParams> {
  final PokemonRepository repository;

  GetPokemons(this.repository);

  @override
  Future<Either<Failure, List<Pokemon>>> call(GetPokemonParams params) async {
    return repository.getPokemons(limit: params.limit, offset: params.offset);
  }
}

class GetPokemonParams {
  final int limit;
  final int offset;

  const GetPokemonParams({required this.limit, this.offset = 0});
}
