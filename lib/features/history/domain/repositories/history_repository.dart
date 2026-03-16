import 'package:dartz/dartz.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class HistoryRepository {
  Future<Either<Failure, void>> addToHistory(MovieEntity movie);
  Future<Either<Failure, List<MovieEntity>>> getHistory();
}
