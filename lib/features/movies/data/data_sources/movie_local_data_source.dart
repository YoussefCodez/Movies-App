import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/movie_entity.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheMovies(List<MovieEntity> movies);
  Future<List<MovieEntity>> getCachedMovies();
  Future<void> cacheMovieDetails(MovieEntity movie);
  Future<MovieEntity?> getCachedMovieDetails(int movieId);
}

@LazySingleton(as: MovieLocalDataSource)
class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static const String _moviesBoxName = 'movies_box_v11';
  static const String _movieDetailsBoxName = 'movie_details_box_v11';

  @override
  Future<void> cacheMovies(List<MovieEntity> movies) async {
    final box = await Hive.openBox<MovieEntity>(_moviesBoxName);
    await box.clear();
    await box.addAll(movies);
  }

  @override
  Future<List<MovieEntity>> getCachedMovies() async {
    final box = await Hive.openBox<MovieEntity>(_moviesBoxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheMovieDetails(MovieEntity movie) async {
    final box = await Hive.openBox<MovieEntity>(_movieDetailsBoxName);
    await box.put(movie.id, movie);
  }

  @override
  Future<MovieEntity?> getCachedMovieDetails(int movieId) async {
    final box = await Hive.openBox<MovieEntity>(_movieDetailsBoxName);
    return box.get(movieId);
  }
}
