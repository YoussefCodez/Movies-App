import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

@injectable
class GetSimilarMoviesUseCase {
  final MovieRepository repository;

  GetSimilarMoviesUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call(int movieId) {
    return repository.getSimilarMovies(movieId);
  }
}
