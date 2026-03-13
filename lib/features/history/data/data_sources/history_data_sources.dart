import '../../../movies/domain/entities/movie_entity.dart';

abstract class HistoryRemoteDataSource {
  Future<void> addToHistory(MovieEntity movie);
  Future<List<MovieEntity>> getHistory();
}

abstract class HistoryLocalDataSource {
  Future<void> addToHistory(MovieEntity movie);
  Future<List<MovieEntity>> getHistory();
  Future<void> cacheHistory(List<MovieEntity> movies);
}
