import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

@lazySingleton
class GetMovieDetailsUseCase {
  final MovieRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<Either<Failure, MovieEntity>> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}
