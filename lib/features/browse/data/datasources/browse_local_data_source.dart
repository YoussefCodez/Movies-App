import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class BrowseLocalDataSource {
  Future<void> cacheMovies(String genre, List<MovieEntity> movies);
  Future<List<MovieEntity>?> getCachedMovies(String genre);
  Future<void> clearCache();
}

@LazySingleton(as: BrowseLocalDataSource)
class BrowseLocalDataSourceImpl implements BrowseLocalDataSource {
  static const String boxName = 'browse_movies_box';

  Future<Box<List>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<List>(boxName);
    }
    return await Hive.openBox<List>(boxName);
  }

  @override
  Future<void> cacheMovies(String genre, List<MovieEntity> movies) async {
    final box = await _openBox();
    await box.put('browse_movies_$genre', movies);
  }

  @override
  Future<List<MovieEntity>?> getCachedMovies(String genre) async {
    final box = await _openBox();
    final data = box.get('browse_movies_$genre');
    if (data != null) {
      return data.cast<MovieEntity>();
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }
}
