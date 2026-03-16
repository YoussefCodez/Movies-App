import '../../../movies/domain/entities/movie_entity.dart';

abstract class WishlistLocalDataSource {
  Future<void> addToWishlist(MovieEntity movie);
  Future<void> removeFromWishlist(int movieId);
  Future<List<MovieEntity>> getWishlist();
  Future<void> cacheWishlist(List<MovieEntity> movies);
  Future<bool> isInWishlist(int movieId);
}
