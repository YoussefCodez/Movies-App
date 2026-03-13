// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponse _$MovieResponseFromJson(Map<String, dynamic> json) =>
    MovieResponse(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : MovieData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieResponseToJson(MovieResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

MovieData _$MovieDataFromJson(Map<String, dynamic> json) => MovieData(
      movieCount: (json['movie_count'] as num?)?.toInt(),
      movies: (json['movies'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieDataToJson(MovieData instance) => <String, dynamic>{
      'movie_count': instance.movieCount,
      'movies': instance.movies,
    };

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      descriptionFull: json['description_full'] as String?,
      mediumCoverImage: json['medium_cover_image'] as String?,
      rating: json['rating'] as num?,
      year: (json['year'] as num?)?.toInt(),
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      runtime: (json['runtime'] as num?)?.toInt(),
      backgroundImage: json['background_image'] as String?,
      likeCount: (json['like_count'] as num?)?.toInt(),
      screenshot1: json['medium_screenshot_image1'] as String?,
      screenshot2: json['medium_screenshot_image2'] as String?,
      screenshot3: json['medium_screenshot_image3'] as String?,
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'description_full': instance.descriptionFull,
      'medium_cover_image': instance.mediumCoverImage,
      'rating': instance.rating,
      'year': instance.year,
      'genres': instance.genres,
      'runtime': instance.runtime,
      'background_image': instance.backgroundImage,
      'like_count': instance.likeCount,
      'medium_screenshot_image1': instance.screenshot1,
      'medium_screenshot_image2': instance.screenshot2,
      'medium_screenshot_image3': instance.screenshot3,
      'cast': instance.cast,
    };

CastModel _$CastModelFromJson(Map<String, dynamic> json) => CastModel(
      name: json['name'] as String?,
      characterName: json['character_name'] as String?,
      urlSmallImage: json['url_small_image'] as String?,
    );

Map<String, dynamic> _$CastModelToJson(CastModel instance) => <String, dynamic>{
      'name': instance.name,
      'character_name': instance.characterName,
      'url_small_image': instance.urlSmallImage,
    };

MovieDetailsResponse _$MovieDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    MovieDetailsResponse(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : MovieDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieDetailsResponseToJson(
        MovieDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

MovieDetailsData _$MovieDetailsDataFromJson(Map<String, dynamic> json) =>
    MovieDetailsData(
      movie: json['movie'] == null
          ? null
          : MovieModel.fromJson(json['movie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieDetailsDataToJson(MovieDetailsData instance) =>
    <String, dynamic>{
      'movie': instance.movie,
    };
