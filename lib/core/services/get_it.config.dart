// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/delete_account_use_case.dart'
    as _i353;
import '../../features/auth/domain/use_cases/get_user_data_use_case.dart'
    as _i789;
import '../../features/auth/domain/use_cases/log_in_use_case.dart' as _i957;
import '../../features/auth/domain/use_cases/reset_password_use_case.dart'
    as _i169;
import '../../features/auth/domain/use_cases/sign_in_with_google_use_case.dart'
    as _i247;
import '../../features/auth/domain/use_cases/sign_out_use_case.dart' as _i131;
import '../../features/auth/domain/use_cases/sign_up_use_case.dart' as _i179;
import '../../features/auth/domain/use_cases/update_user_data_use_case.dart'
    as _i120;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/profile/presentation/cubits/profile_cubit.dart' as _i319;
import '../di/app_module.dart' as _i207;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => appModule.googleSignIn);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => appModule.firestore);
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i957.LogInUseCase>(
      () => _i957.LogInUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i169.ResetPasswordUseCase>(
      () => _i169.ResetPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i247.SignInWithGoogleUseCase>(
      () => _i247.SignInWithGoogleUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i131.SignOutUseCase>(
      () => _i131.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i179.SignUpUseCase>(
      () => _i179.SignUpUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        signUpUseCase: gh<_i179.SignUpUseCase>(),
        logInUseCase: gh<_i957.LogInUseCase>(),
        signOutUseCase: gh<_i131.SignOutUseCase>(),
        resetPasswordUseCase: gh<_i169.ResetPasswordUseCase>(),
        signInWithGoogleUseCase: gh<_i247.SignInWithGoogleUseCase>(),
      ),
    );
    gh.lazySingleton<_i353.DeleteAccountUseCase>(
      () => _i353.DeleteAccountUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i789.GetUserDataUseCase>(
      () => _i789.GetUserDataUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i120.UpdateUserDataUseCase>(
      () => _i120.UpdateUserDataUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i319.ProfileCubit>(
      () => _i319.ProfileCubit(
        gh<_i789.GetUserDataUseCase>(),
        gh<_i120.UpdateUserDataUseCase>(),
        gh<_i353.DeleteAccountUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i207.AppModule {}
