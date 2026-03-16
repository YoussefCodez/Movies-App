import '../../../movies/domain/entities/movie_entity.dart';

class MovieWishlistModel extends MovieEntity {
  MovieWishlistModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.mediumCoverImage,
    required super.rating,
    required super.year,
    required super.genres,
    super.runtime,
    super.backgroundImage,
    super.likeCount,
    super.screenshots,
    super.cast,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'mediumCoverImage': mediumCoverImage,
      'rating': rating,
      'year': year,
      'genres': genres,
      'runtime': runtime,
      'backgroundImage': backgroundImage,
      'likeCount': likeCount,
      'screenshots': screenshots,
      'cast': cast
          .map(
            (c) => {
              'name': c.name,
              'characterName': c.characterName,
              'urlSmallImage': c.urlSmallImage,
            },
          )
          .toList(),
    };
  }

  factory MovieWishlistModel.fromFirestore(Map<String, dynamic> json) {
    return MovieWishlistModel(
      id: json['id'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? '',
      mediumCoverImage: json['mediumCoverImage'] as String,
      rating: (json['rating'] as num).toDouble(),
      year: json['year'] as int,
      genres: List<String>.from(json['genres'] ?? []),
      runtime: json['runtime'] as int?,
      backgroundImage: json['backgroundImage'] as String?,
      likeCount: json['likeCount'] as int?,
      screenshots: List<String>.from(json['screenshots'] ?? []),
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map(
                (c) => CastEntity(
                  name: c['name'] as String,
                  characterName: c['characterName'] as String,
                  urlSmallImage: c['urlSmallImage'] as String?,
                ),
              )
              .toList() ??
          [],
    );
  }

  factory MovieWishlistModel.fromEntity(MovieEntity entity) {
    return MovieWishlistModel(
      id: entity.id,
      title: entity.title,
      summary: entity.summary,
      mediumCoverImage: entity.mediumCoverImage,
      rating: entity.rating,
      year: entity.year,
      genres: entity.genres,
      runtime: entity.runtime,
      backgroundImage: entity.backgroundImage,
      likeCount: entity.likeCount,
      screenshots: entity.screenshots,
      cast: entity.cast,
    );
  }
}
