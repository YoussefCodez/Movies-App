import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignOutUseCase {
  final AuthRepository repository;
  SignOutUseCase(this.repository);

  Future<Either<String, void>> call() {
    return repository.signOut();
  }
}
