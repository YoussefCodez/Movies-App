import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import 'wishlist_local_data_source.dart';

@LazySingleton(as: WishlistLocalDataSource)
class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  static const String boxName = 'wishlist_box';

  @override
  Future<void> addToWishlist(MovieEntity movie) async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    await box.put(movie.id, movie);
  }

  @override
  Future<void> removeFromWishlist(int movieId) async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    await box.delete(movieId);
  }

  @override
  Future<List<MovieEntity>> getWishlist() async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheWishlist(List<MovieEntity> movies) async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    await box.clear();
    for (var movie in movies) {
      await box.put(movie.id, movie);
    }
  }

  @override
  Future<bool> isInWishlist(int movieId) async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    return box.containsKey(movieId);
  }
}
