import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/data/models/user_model.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<UserEntity> signInWithEmail(String email, String password) {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<String, UserEntity>> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credintal = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final UserModel userModel = UserModel(
        uid: credintal.user!.uid,
        email: credintal.user!.email,
        displayName: credintal.user!.displayName,
        phoneNumber: credintal.user!.phoneNumber,
        wishList: [],
      );
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Left('The account already exists for that email.');
      }
    } catch (e) {
      return Left(e.toString());
    }
    return Left("Something went wrong");
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Stream<UserEntity> get authStateChanges {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }
}
