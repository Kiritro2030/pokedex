import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/core/error/exceptions.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:pokedex/features/pokemon/data/datasources/favorites_local_data_source.dart';
import 'package:pokedex/features/pokemon/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl extends FavoritesRepository {
  final FavoritesLocalDataSource dataSource;

  FavoritesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> addFavorite(int pokemonId) async {
    try {
      final favorites = await dataSource.getFavorites();

      favorites.add(pokemonId);
      return Right(dataSource.saveFavoritesIds(favorites));
    } on ServerException catch (e) {
      return Left(CacheFailure("Error al obtener: ${e.message}"));
    } catch (e) {
      return Left(ServerFailure("Error inesperado: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, Set<int>>> getFavoritesId() async {
    try {
      return Right(await dataSource.getFavorites());
    } on ServerException catch (e) {
      return Left(CacheFailure("Error en el servidor: ${e.message}"));
    } catch (e) {
      return Left(ServerFailure("Error inesperado: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int pokemonId) async {
    try {
      final favorites = await dataSource.getFavorites();
      favorites.remove(pokemonId);
      return Right(await dataSource.saveFavoritesIds(favorites));
    } on ServerException catch (e) {
      return Left(CacheFailure("Error en el servidor: ${e.message}"));
    } catch (e) {
      return Left(ServerFailure("Error inesperado: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> saveFavoriteIds(Set<int> ids) async {
    try {
      return Right(await dataSource.saveFavoritesIds(ids));
    } on ServerException catch (e) {
      return Left(CacheFailure("Error en el servidor: ${e.message}"));
    } catch (e) {
      return Left(ServerFailure("Error inesperado: ${e.toString()}"));
    }
  }
}
