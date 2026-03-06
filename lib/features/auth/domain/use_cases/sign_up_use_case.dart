import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  Future<Either<String, UserEntity>> call(
    String email,
    String password,
    String name,
  ) async {
    return await authRepository.signUpWithEmail(email, password, name);
  }
}