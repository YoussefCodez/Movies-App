import 'package:hive/hive.dart';

part 'movie_entity.g.dart';

@HiveType(typeId: 1)
class CastEntity {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String characterName;
  @HiveField(2)
  final String? urlSmallImage;

  CastEntity({
    required this.name,
    required this.characterName,
    this.urlSmallImage,
  });
}

@HiveType(typeId: 0)
class MovieEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String summary;
  @HiveField(3)
  final String mediumCoverImage;
  @HiveField(4)
  final double rating;
  @HiveField(5)
  final int year;
  @HiveField(6)
  final List<String> genres;
  @HiveField(7)
  final int? runtime;
  @HiveField(8)
  final String? backgroundImage;
  @HiveField(9)
  final int? likeCount;
  @HiveField(10)
  final List<String> screenshots;
  @HiveField(11)
  final List<CastEntity> cast;

  MovieEntity({
    required this.id,
    required this.title,
    required this.summary,
    required this.mediumCoverImage,
    required this.rating,
    required this.year,
    required this.genres,
    this.runtime,
    this.backgroundImage,
    this.likeCount,
    this.screenshots = const [],
    this.cast = const [],
  });
}
