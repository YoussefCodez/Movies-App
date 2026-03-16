import 'package:injectable/injectable.dart';
import 'package:movies/core/network/api_service.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieResponse> getMovies();
  Future<MovieDetailsResponse> getMovieDetails(int movieId);
  Future<MovieResponse> getSimilarMovies(int movieId);
}

@LazySingleton(as: MovieRemoteDataSource)
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiService apiService;

  MovieRemoteDataSourceImpl(this.apiService);

  @override
  Future<MovieResponse> getMovies() {
    return apiService.getMovies();
  }

  @override
  Future<MovieDetailsResponse> getMovieDetails(int movieId) {
    return apiService.getMovieDetails(
      movieId,
      withImages: true,
      withCast: true,
    );
  }

  @override
  Future<MovieResponse> getSimilarMovies(int movieId) {
    return apiService.getSimilarMovies(movieId);
  }
}
