import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../data_sources/history_data_sources.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> addToHistory(MovieEntity movie) async {
    try {
      // Always save locally first for immediate UI response
      await localDataSource.addToHistory(movie);

      // Try remote, but don't break if it fails (offline or permission issue)
      try {
        await remoteDataSource.addToHistory(movie);
      } catch (e) {
        debugPrint('Remote History Sync Failed: $e');
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getHistory() async {
    try {
      final localData = await localDataSource.getHistory();

      try {
        final remoteData = await remoteDataSource.getHistory();
        if (remoteData.isNotEmpty || localData.isEmpty) {
          await localDataSource.cacheHistory(remoteData);
          return Right(remoteData);
        }
      } catch (e) {
        if (localData.isNotEmpty) {
          return Right(localData);
        }
        rethrow;
      }

      return Right(localData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
