import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../data_sources/wishlist_local_data_source.dart';
import '../data_sources/wishlist_remote_data_source.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> addToWishlist(MovieEntity movie) async {
    try {
      await localDataSource.addToWishlist(movie);
      await remoteDataSource.addToWishlist(movie);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(int movieId) async {
    try {
      await localDataSource.removeFromWishlist(movieId);
      await remoteDataSource.removeFromWishlist(movieId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getWishlist() async {
    try {
      // Check local first
      final localData = await localDataSource.getWishlist();

      try {
        // Try to get from remote to stay synced
        final remoteData = await remoteDataSource.getWishlist();

        // Sync local with remote if remote has data
        if (remoteData.isNotEmpty || localData.isEmpty) {
          await localDataSource.cacheWishlist(remoteData);
          return Right(remoteData);
        }
      } catch (e) {
        // If remote fails, return local data if available
        if (localData.isNotEmpty) {
          return Right(localData);
        }
        rethrow;
      }

      return Right(localData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(int movieId) async {
    try {
      final exists = await localDataSource.isInWishlist(movieId);
      return Right(exists);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
