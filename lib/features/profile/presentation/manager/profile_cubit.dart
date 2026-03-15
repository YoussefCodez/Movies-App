import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  final FirebaseAuth _auth;

  ProfileCubit(this._repository, this._auth) : super(ProfileInitial());

  final List<String> availableAvatars = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
    'assets/images/avatar7.png',
    'assets/images/avatar8.png',
    'assets/images/avatar9.png',
  ];

  Future<void> loadProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      emit(const ProfileError('User not logged in'));
      return;
    }

    emit(ProfileLoading());
    try {
      final user = await _repository.getUserProfile(currentUser.uid);

      final prefs = await SharedPreferences.getInstance();
      int? savedIndex = prefs.getInt('selected_avatar_index');
      int finalIndex;
      if (savedIndex == null ||
          savedIndex < 0 ||
          savedIndex >= availableAvatars.length) {
        finalIndex = Random().nextInt(availableAvatars.length);
        await prefs.setInt('selected_avatar_index', finalIndex);
      } else {
        finalIndex = savedIndex;
      }

      final updatedUser = user.copyWith(
        avatarPath: availableAvatars[finalIndex],
      );

      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    if (state is! ProfileLoaded) return;
    final currentUser = (state as ProfileLoaded).user;

    emit(ProfileLoading());

    final updatedUser = currentUser.copyWith(
      name: name,
      phoneNumber: phone,
      avatarPath: avatar,
    );

    try {
      await _repository.updateUserProfile(updatedUser);

      if (avatar != null) {
        final index = availableAvatars.indexOf(avatar);
        if (index != -1) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('selected_avatar_index', index);
        }
      }

      emit(ProfileUpdateSuccess(updatedUser));
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
      emit(ProfileLoaded(currentUser));
    }
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoading());
    try {
      await _repository.deleteAccount();
      emit(ProfileDeleteSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        emit(ProfileReauthenticationRequired());
      } else {
        emit(ProfileError(e.message ?? e.toString()));
        loadProfile();
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile();
    }
  }

  Future<void> reauthenticateAndDelete(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;

    emit(ProfileLoading());
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await deleteAccount();
    } catch (e) {
      emit(ProfileError(e.toString()));

    }
  }

  void reset() {
    emit(ProfileInitial());
  }
}
