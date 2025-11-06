import 'package:dartz/dartz.dart';
import 'package:pokedex/core/error/failures.dart';

abstract class FavoritesRepository {
  /// Obtiene los IDs de favoritos guardados
  Future<Either<Failure, Set<int>>> getFavoritesId();

  /// Agrega un ID a favoritos
  Future<Either<Failure, void>> addFavorite(int pokemonId);

  /// Elimina un ID de favoritos
  Future<Either<Failure, void>> removeFavorite(int pokemonId);

  /// Agrega un ID a favoritos
  Future<Either<Failure, void>> saveFavoriteIds(Set<int> ids);
}
