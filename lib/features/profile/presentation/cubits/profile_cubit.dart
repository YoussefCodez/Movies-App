import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/profile/domain/entities/user_profile.dart';
import 'package:movies/features/profile/domain/repositories/profile_repository.dart';

// States
class ProfileState extends Equatable {
  final UserProfile? userProfile;
  final bool isLoading;
  final int selectedTabIndex;
  final String? errorMessage;

  const ProfileState({
    this.userProfile,
    this.isLoading = false,
    this.selectedTabIndex = 0,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    userProfile,
    isLoading,
    selectedTabIndex,
    errorMessage,
  ];

  ProfileState copyWith({
    UserProfile? userProfile,
    bool? isLoading,
    int? selectedTabIndex,
    String? errorMessage,
  }) {
    return ProfileState(
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await _repository.getUserProfile('123');
      emit(state.copyWith(userProfile: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void setTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    if (state.userProfile == null) return;

    emit(state.copyWith(isLoading: true));

    final updatedProfile = state.userProfile!.copyWith(
      name: name,
      phoneNumber: phone,
      avatarPath: avatar,
    );

    try {
      await _repository.updateUserProfile(updatedProfile);
      emit(state.copyWith(userProfile: updatedProfile, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

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
}
