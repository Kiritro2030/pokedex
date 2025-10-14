import 'package:pokedex/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class Usecase<T, Params> {
  /// Ejecuta el caso de uso
  // / Retorna Either<Failure, Type>
  /// - Left = Error (Failure)
  /// - Right = Éxito (Type)
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
