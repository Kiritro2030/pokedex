import 'package:dartz/dartz.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokemon/domain/repositories/favorites_repository.dart';

class ToggleFavorite extends Usecase<void, ToggleFavoriteParams> {
  final FavoritesRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) async {
    final currentResults = await repository.getFavoritesId();

    return currentResults.fold((failure) => Left(failure), (currentIds) async {
      if (currentIds.contains(params.id)) {
        return await repository.removeFavorite(params.id);
      } else {
        return await repository.addFavorite(params.id);
      }
    });
  }
}

class ToggleFavoriteParams {
  final int id;
  ToggleFavoriteParams(this.id);
}
