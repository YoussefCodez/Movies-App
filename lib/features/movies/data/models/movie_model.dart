import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie_entity.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieResponse {
  final String? status;
  final MovieData? data;

  MovieResponse({this.status, this.data});

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
}

@JsonSerializable()
class MovieData {
  @JsonKey(name: 'movie_count')
  final int? movieCount;
  final List<MovieModel>? movies;

  MovieData({this.movieCount, this.movies});

  factory MovieData.fromJson(Map<String, dynamic> json) =>
      _$MovieDataFromJson(json);
}

@JsonSerializable()
class MovieModel {
  final int? id;
  final String? title;
  final String? summary;
  @JsonKey(name: 'description_full')
  final String? descriptionFull;
  @JsonKey(name: 'medium_cover_image')
  final String? mediumCoverImage;
  final num? rating;
  final int? year;
  final List<String>? genres;
  final int? runtime;
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  @JsonKey(name: 'like_count')
  final int? likeCount;
  @JsonKey(name: 'medium_screenshot_image1')
  final String? screenshot1;
  @JsonKey(name: 'medium_screenshot_image2')
  final String? screenshot2;
  @JsonKey(name: 'medium_screenshot_image3')
  final String? screenshot3;
  final List<CastModel>? cast;

  MovieModel({
    this.id,
    this.title,
    this.summary,
    this.descriptionFull,
    this.mediumCoverImage,
    this.rating,
    this.year,
    this.genres,
    this.runtime,
    this.backgroundImage,
    this.likeCount,
    this.screenshot1,
    this.screenshot2,
    this.screenshot3,
    this.cast,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  MovieEntity toEntity() {
    final screenshots = <String>[];
    if (screenshot1 != null) screenshots.add(screenshot1!);
    if (screenshot2 != null) screenshots.add(screenshot2!);
    if (screenshot3 != null) screenshots.add(screenshot3!);

    return MovieEntity(
      id: id ?? 0,
      title: title ?? '',
      summary: summary ?? descriptionFull ?? '',
      mediumCoverImage: mediumCoverImage ?? '',
      rating: (rating ?? 0.0).toDouble(),
      year: year ?? 0,
      genres: genres ?? [],
      runtime: runtime,
      backgroundImage: backgroundImage,
      likeCount: likeCount,
      screenshots: screenshots,
      cast: cast?.map((c) => c.toEntity()).toList() ?? [],
    );
  }
}

@JsonSerializable()
class CastModel {
  final String? name;
  @JsonKey(name: 'character_name')
  final String? characterName;
  @JsonKey(name: 'url_small_image')
  final String? urlSmallImage;

  CastModel({this.name, this.characterName, this.urlSmallImage});

  factory CastModel.fromJson(Map<String, dynamic> json) =>
      _$CastModelFromJson(json);

  CastEntity toEntity() {
    return CastEntity(
      name: name ?? '',
      characterName: characterName ?? '',
      urlSmallImage: urlSmallImage,
    );
  }
}

@JsonSerializable()
class MovieDetailsResponse {
  final String? status;
  final MovieDetailsData? data;

  MovieDetailsResponse({this.status, this.data});

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsResponseFromJson(json);
}

@JsonSerializable()
class MovieDetailsData {
  final MovieModel? movie;

  MovieDetailsData({this.movie});

  factory MovieDetailsData.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsDataFromJson(json);
}
