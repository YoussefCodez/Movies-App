import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/browse_repository.dart';

@lazySingleton
class GetMoviesByGenreUseCase {
  final BrowseRepository repository;

  GetMoviesByGenreUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call(String genre) async {
    return await repository.getMoviesByGenre(genre);
  }
}
