import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../data_sources/movie_local_data_source.dart';
import '../data_sources/movie_remote_data_source.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies() async {
    try {
      final response = await remoteDataSource.getMovies();
      final movies =
          response.data?.movies?.map((m) => m.toEntity()).toList() ?? [];

      if (movies.isNotEmpty) {
        localDataSource.cacheMovies(movies).catchError((_) {});
      }

      return Right(movies);
    } catch (e) {
      try {
        final cachedMovies = await localDataSource.getCachedMovies();
        if (cachedMovies.isNotEmpty) {
          return Right(cachedMovies);
        }
      } catch (_) {}

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieEntity>> getMovieDetails(int movieId) async {
    try {
      final response = await remoteDataSource.getMovieDetails(movieId);
      final movie = response.data?.movie?.toEntity();

      if (movie != null) {
        localDataSource.cacheMovieDetails(movie).catchError((_) {});
        return Right(movie);
      } else {
        final cachedMovie = await localDataSource.getCachedMovieDetails(
          movieId,
        );
        if (cachedMovie != null) return Right(cachedMovie);

        return const Left(ServerFailure("Movie not found"));
      }
    } catch (e) {
      try {
        final cachedMovie = await localDataSource.getCachedMovieDetails(
          movieId,
        );
        if (cachedMovie != null) return Right(cachedMovie);
      } catch (_) {}

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    try {
      var movies = await localDataSource.getCachedMovies();

      if (movies.isEmpty) {
        final response = await remoteDataSource.getMovies();
        movies = response.data?.movies?.map((m) => m.toEntity()).toList() ?? [];
        if (movies.isNotEmpty) {
          await localDataSource.cacheMovies(movies);
        }
      }

      final filteredMovies = movies
          .where(
            (movie) => movie.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      return Right(filteredMovies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getSimilarMovies(int movieId) async {
    try {
      final response = await remoteDataSource.getSimilarMovies(movieId);
      final movies = response.data?.movies?.map((m) => m.toEntity()).toList() ?? [];
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
