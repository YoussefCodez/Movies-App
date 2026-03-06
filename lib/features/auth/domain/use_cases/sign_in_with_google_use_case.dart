import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class SignInWithGoogleUseCase {
  final AuthRepository authRepository;

  SignInWithGoogleUseCase(this.authRepository);

  Future<Either<String, UserEntity>> call() async {
    return await authRepository.signInWithGoogle();
  }
}
