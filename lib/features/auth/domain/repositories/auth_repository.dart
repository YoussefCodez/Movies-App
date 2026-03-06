import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential?> signInWithEmail(String email, String password);
  Future<UserCredential?> signUpWithEmail(String email, String password, String name);
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<User?> get authStateChanges;
}
