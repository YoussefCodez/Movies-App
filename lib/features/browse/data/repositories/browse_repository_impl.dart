import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../domain/repositories/browse_repository.dart';
import '../datasources/browse_local_data_source.dart';
import '../datasources/browse_remote_data_source.dart';

@LazySingleton(as: BrowseRepository)
class BrowseRepositoryImpl implements BrowseRepository {
  final BrowseRemoteDataSource remoteDataSource;
  final BrowseLocalDataSource localDataSource;

  BrowseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> getMoviesByGenre(
    String genre,
  ) async {
    try {
      final cachedMovies = await localDataSource.getCachedMovies(genre);
      if (cachedMovies != null && cachedMovies.isNotEmpty) {
        return Right(cachedMovies);
      }

      final remoteMoviesModels = await remoteDataSource.getMoviesByGenre(genre);
      final remoteMovies = remoteMoviesModels
          .map((model) => model.toEntity())
          .toList();

      await localDataSource.cacheMovies(genre, remoteMovies);

      if (remoteMovies.isEmpty) {
        return const Left(ServerFailure('No movies found for this genre'));
      }

      return Right(remoteMovies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
