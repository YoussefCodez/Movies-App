import 'package:dartz/dartz.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';


abstract class AuthRepository {
  Future<Either<String, UserEntity>> signUpWithEmail(
    String email,
    String password,
    String name,
  );
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<UserEntity> get authStateChanges;
}
