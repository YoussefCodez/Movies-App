import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UpdateUserDataUseCase {
  final AuthRepository _repository;

  UpdateUserDataUseCase(this._repository);

  Future<Either<String, void>> call(UserEntity user) async {
    return await _repository.updateUserData(user);
  }
}
