import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LogInUseCase {
  final AuthRepository repository;
  LogInUseCase(this.repository);

  Future<Either<String, UserEntity>> call(String email, String password) {
    return repository.signInWithEmail(email, password);
  }
}
