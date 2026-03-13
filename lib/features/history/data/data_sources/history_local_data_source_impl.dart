import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import 'history_data_sources.dart';

@LazySingleton(as: HistoryLocalDataSource)
class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  static const String boxName = 'history_box';

  @override
  Future<void> addToHistory(MovieEntity movie) async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    // Remove if exists to ensure it's added at the end (newest)
    await box.delete(movie.id);
    await box.put(movie.id, movie);
  }

  @override
  Future<List<MovieEntity>> getHistory() async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    // Return newest first (reverse of the box values)
    return box.values.toList().reversed.toList();
  }

  @override
  Future<void> cacheHistory(List<MovieEntity> movies) async {
    final box = await Hive.openBox<MovieEntity>(boxName);
    await box.clear();
    for (var movie in movies) {
      await box.put(movie.id, movie);
    }
  }
}
