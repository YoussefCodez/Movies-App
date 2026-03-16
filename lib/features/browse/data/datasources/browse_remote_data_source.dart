import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
import '../../../movies/data/models/movie_model.dart';

abstract class BrowseRemoteDataSource {
  Future<List<MovieModel>> getMoviesByGenre(String genre);
}

@LazySingleton(as: BrowseRemoteDataSource)
class BrowseRemoteDataSourceImpl implements BrowseRemoteDataSource {
  final ApiService _apiService;

  BrowseRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<MovieModel>> getMoviesByGenre(String genre) async {
    final response = await _apiService.getMoviesByGenre(genre);
    return response.data?.movies ?? [];
  }
}
