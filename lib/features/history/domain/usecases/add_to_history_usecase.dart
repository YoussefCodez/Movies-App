import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/history_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddToHistoryUseCase {
  final HistoryRepository repository;

  AddToHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call(MovieEntity movie) {
    return repository.addToHistory(movie);
  }
}
