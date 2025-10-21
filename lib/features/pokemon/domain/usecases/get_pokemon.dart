import 'package:dartz/dartz.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_repository.dart';

class GetPokemon implements Usecase<Pokemon, GetPokemonParams> {
  final PokemonRepository repository;

  GetPokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(GetPokemonParams params) async {
    return await repository.getPokemon(id: params.id);
  }
}

class GetPokemonParams {
  final String id;

  GetPokemonParams({required this.id});
}
