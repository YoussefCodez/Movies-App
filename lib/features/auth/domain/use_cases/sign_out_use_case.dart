import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<void> call() async {
    return await authRepository.signOut();
  }
}