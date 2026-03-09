import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<Either<String, UserEntity>> call(
    String email,
    String password,
    String name,
  ) {
    return repository.signUpWithEmail(email, password, name);
  }
}
