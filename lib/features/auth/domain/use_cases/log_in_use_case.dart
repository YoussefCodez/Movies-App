import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class LogInUseCase {
  final AuthRepository authRepository;

  LogInUseCase(this.authRepository);

  Future<Either<String, UserEntity>> call(
    String email,
    String password,
  ) async {
    return await authRepository.signInWithEmail(email, password);
  }
}