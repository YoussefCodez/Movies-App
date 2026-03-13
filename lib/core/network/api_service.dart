import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/movies/data/models/movie_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://movies-api.accel.li/api/v2/")
@lazySingleton
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @GET("list_movies.json")
  Future<MovieResponse> getMovies();

  @GET("list_movies.json")
  Future<MovieResponse> getMoviesByGenre(@Query("genre") String genre);

  @GET("movie_details.json")
  Future<MovieDetailsResponse> getMovieDetails(
    @Query("movie_id") int movieId, {
    @Query("with_images") bool withImages = true,
    @Query("with_cast") bool withCast = true,
  });
}

@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio => Dio();
}
