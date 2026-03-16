import 'package:dartz/dartz.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class WishlistRepository {
  Future<Either<Failure, void>> addToWishlist(MovieEntity movie);
  Future<Either<Failure, void>> removeFromWishlist(int movieId);
  Future<Either<Failure, List<MovieEntity>>> getWishlist();
  Future<Either<Failure, bool>> isInWishlist(int movieId);
}
