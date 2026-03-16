import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRepositoryImpl(this._firestore, this._auth);

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      return UserProfile(
        uid: uid,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        avatarPath: data['avatarPath'] ?? 'assets/images/avatar1.png',
      );
    } else {
      final user = _auth.currentUser;
      return UserProfile(
        uid: uid,
        name: user?.displayName ?? 'User',
        email: user?.email ?? '',
        phoneNumber: '',
        avatarPath: 'assets/images/avatar1.png',
      );
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set({
      'name': profile.name,
      'email': profile.email,
      'phoneNumber': profile.phoneNumber,
      'avatarPath': profile.avatarPath,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final uid = user.uid;

    await _firestore.collection('users').doc(uid).delete();

    await user.delete();
  }
}
