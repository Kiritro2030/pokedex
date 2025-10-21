import 'package:dartz/dartz.dart';
import 'package:pokedex/core/error/exceptions.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:pokedex/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl extends PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Pokemon>> getPokemon({required String id}) async {
    try {
      final pokemon = await remoteDataSource.getPokemon(id: id);

      return Right(pokemon.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Error inesperado: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemons({
    required int limit,
    int offset = 0,
  }) async {
    try {
      final pokemonModels = await remoteDataSource.getPokemons(
        limit: limit,
        offset: offset,
      );

      final pokemons = pokemonModels.map((model) => model.toEntity()).toList();

      return Right(pokemons);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
}
