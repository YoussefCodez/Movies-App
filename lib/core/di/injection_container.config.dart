// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repositories/firebase_auth_repository.dart'
    as _i900;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/log_in_use_case.dart' as _i957;
import '../../features/auth/domain/use_cases/reset_password_use_case.dart'
    as _i169;
import '../../features/auth/domain/use_cases/sign_in_with_google_use_case.dart'
    as _i247;
import '../../features/auth/domain/use_cases/sign_out_use_case.dart' as _i131;
import '../../features/auth/domain/use_cases/sign_up_use_case.dart' as _i179;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i900.FirebaseAuthRepository(),
    );
    gh.factory<_i957.LogInUseCase>(
      () => _i957.LogInUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i169.ResetPasswordUseCase>(
      () => _i169.ResetPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i247.SignInWithGoogleUseCase>(
      () => _i247.SignInWithGoogleUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i131.SignOutUseCase>(
      () => _i131.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i179.SignUpUseCase>(
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
    return this;
  }
}
