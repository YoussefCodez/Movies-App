import 'package:hive/hive.dart';

class HiveService {
  static Future<void> clearAllBoxes() async {
    final boxNames = [
      'wishlist_box',
      'history_box',
      'movies_box_v11',
      'movie_details_box_v11',
    ];

    for (var name in boxNames) {
      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box(name).clear();
        } else {
          await Hive.deleteBoxFromDisk(name);
        }
      } catch (e) {
        // If there's a type mismatch or other error, try deleting from disk
        await Hive.deleteBoxFromDisk(name);
      }
    }
  }
}
