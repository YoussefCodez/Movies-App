import '../../../movies/domain/entities/movie_entity.dart';

abstract class WishlistRemoteDataSource {
  Future<void> addToWishlist(MovieEntity movie);
  Future<void> removeFromWishlist(int movieId);
  Future<List<MovieEntity>> getWishlist();
}
