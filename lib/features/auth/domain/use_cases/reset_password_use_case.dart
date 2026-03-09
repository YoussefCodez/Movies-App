import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<String, void>> call(String email) {
    return repository.resetPassword(email);
  }
}
