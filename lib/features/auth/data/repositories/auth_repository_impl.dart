import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/data/models/user_model.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  AuthRepositoryImpl(this._firebaseAuth, this._googleSignIn, this._firestore);

  @override
  Future<Either<String, UserEntity>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final docSnapshot = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      final userData = docSnapshot.data();

      final UserModel userModel = UserModel(
        uid: credential.user!.uid,
        displayName: userData?['name'] ?? credential.user?.displayName ?? "",
        email: email,
        phoneNumber: userData?['phone'] ?? "",
        wishList:
            (userData?['wishList'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return const Left('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        return const Left('Invalid email or password.');
      }
      return Left(e.message ?? 'Authentication failed');
    } catch (e) {
      return Left(e.toString());
    }
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
      await _firestore.collection('users').doc(credintal.user!.uid).set({
        'uid': credintal.user!.uid,
        'name': name,
        'email': email,
        'phone': '',
        'wishList': [],
      });

      final UserModel userModel = UserModel(
        uid: credintal.user!.uid,
        email: email,
        displayName: name,
        phoneNumber: "",
        wishList: [],
      );
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return const Left('The account already exists for that email.');
      }
      return Left(e.message ?? 'Registration failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Left('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final user = userCredential.user!;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? "",
          'email': user.email ?? "",
          'phone': user.phoneNumber ?? "",
          'wishList': [],
        });
      }

      final userData = userDoc.data();

      final UserModel userModel = UserModel(
        uid: user.uid,
        displayName: userData?['name'] ?? user.displayName ?? "",
        email: user.email ?? "",
        phoneNumber: userData?['phone'] ?? user.phoneNumber ?? "",
        wishList:
            (userData?['wishList'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Google authentication failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<Either<String, void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<Either<String, UserEntity>> getUserData() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Left('User not logged in');
      }

      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (!docSnapshot.exists) {
        return const Left('User data not found in Firestore');
      }

      final userData = docSnapshot.data();

      final UserModel userModel = UserModel(
        uid: user.uid,
        displayName: userData?['name'] ?? user.displayName ?? "",
        email: user.email ?? "",
        phoneNumber: userData?['phone'] ?? user.phoneNumber ?? "",
        wishList:
            (userData?['wishList'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

      return Right(userModel.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateUserData(UserEntity user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': user.displayName,
        'phone': user.phoneNumber,
      });

      await _firebaseAuth.currentUser?.updateDisplayName(user.displayName);

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Left('User not logged in');
      }

      await _firestore.collection('users').doc(user.uid).delete();

      await user.delete();

      return const Right(null);
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        return const Left('Please re-authenticate to delete your account');
      }
      return Left(e.toString());
    }
  }
}
