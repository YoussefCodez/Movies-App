import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository authRepository;

  ResetPasswordUseCase(this.authRepository);

  Future<Either<String, void>> call(String email) async {
    return await authRepository.resetPassword(email);
  }
}
