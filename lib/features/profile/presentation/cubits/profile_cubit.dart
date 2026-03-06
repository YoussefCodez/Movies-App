import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/use_cases/get_user_data_use_case.dart';
import 'package:movies/features/auth/domain/use_cases/update_user_data_use_case.dart';
import 'package:movies/features/auth/domain/use_cases/delete_account_use_case.dart';

class ProfileState {
  // ... existing state
  final UserEntity? user;
  final bool isLoading;
  final String? errorMessage;
  final int selectedTabIndex;
  final bool isAccountDeleted;

  ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.selectedTabIndex = 0,
    this.isAccountDeleted = false,
  });

  ProfileState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? errorMessage,
    int? selectedTabIndex,
    bool? isAccountDeleted,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
    );
  }
}

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetUserDataUseCase _getUserDataUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  ProfileCubit(
    this._getUserDataUseCase,
    this._updateUserDataUseCase,
    this._deleteAccountUseCase,
  ) : super(ProfileState()) {
    getUserProfile();
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

  Future<void> getUserProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getUserDataUseCase.call();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure)),
      (user) => emit(state.copyWith(user: user, isLoading: false)),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    if (currentUser.displayName == name && currentUser.phoneNumber == phone) {
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final updatedUser = UserEntity(
      uid: currentUser.uid,
      displayName: name,
      phoneNumber: phone,
      email: currentUser.email,
      wishList: currentUser.wishList,
    );

    final result = await _updateUserDataUseCase.call(updatedUser);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure)),
      (_) {
        emit(state.copyWith(user: updatedUser, isLoading: false));
      },
    );
  }

  void setTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _deleteAccountUseCase.call();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure)),
      (_) {
        emit(state.copyWith(isLoading: false, isAccountDeleted: true));
      },
    );
  }
}
