import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class BrowseRepository {
  Future<Either<Failure, List<MovieEntity>>> getMoviesByGenre(String genre);
}
