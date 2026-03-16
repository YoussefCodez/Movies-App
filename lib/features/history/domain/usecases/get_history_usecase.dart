import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/history_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call() {
    return repository.getHistory();
  }
}
