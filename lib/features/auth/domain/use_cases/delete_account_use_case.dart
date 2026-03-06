import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class DeleteAccountUseCase {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  Future<Either<String, void>> call() async {
    return await _repository.deleteAccount();
  }
}
