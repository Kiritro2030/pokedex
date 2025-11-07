import 'package:dartz/dartz.dart';
import 'package:pokedex/core/error/failures.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokemon/domain/repositories/favorites_repository.dart';

class GetFavorites extends Usecase<Set<int>, NoParams> {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, Set<int>>> call(params) async {
    final currentResults = await repository.getFavoritesId();

    return currentResults.fold((failure) => Left(failure), (currentIds) {
      return Right(currentIds);
    });
  }
}
