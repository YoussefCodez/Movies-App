// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
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
import '../../features/browse/data/datasources/browse_local_data_source.dart'
    as _i900;
import '../../features/browse/data/datasources/browse_remote_data_source.dart'
    as _i887;
import '../../features/browse/data/repositories/browse_repository_impl.dart'
    as _i791;
import '../../features/browse/domain/repositories/browse_repository.dart'
    as _i221;
import '../../features/browse/domain/usecases/get_movies_by_genre_usecase.dart'
    as _i276;
import '../../features/browse/presentation/cubit/browse_cubit.dart' as _i259;
import '../../features/history/data/data_sources/history_data_sources.dart'
    as _i828;
import '../../features/history/data/data_sources/history_local_data_source_impl.dart'
    as _i21;
import '../../features/history/data/data_sources/history_remote_data_source_impl.dart'
    as _i343;
import '../../features/history/data/repositories/history_repository_impl.dart'
    as _i751;
import '../../features/history/domain/repositories/history_repository.dart'
    as _i142;
import '../../features/history/domain/usecases/add_to_history_usecase.dart'
    as _i962;
import '../../features/history/domain/usecases/get_history_usecase.dart'
    as _i840;
import '../../features/history/presentation/manager/history_cubit.dart'
    as _i154;
import '../../features/movie_details/presentation/manager/movie_details_cubit.dart'
    as _i269;
import '../../features/movies/data/data_sources/movie_local_data_source.dart'
    as _i556;
import '../../features/movies/data/data_sources/movie_remote_data_source.dart'
    as _i404;
import '../../features/movies/data/repositories/movie_repository_impl.dart'
    as _i652;
import '../../features/movies/domain/repositories/movie_repository.dart'
    as _i465;
import '../../features/movies/domain/usecases/get_movie_details_usecase.dart'
    as _i237;
import '../../features/movies/domain/usecases/get_movies_usecase.dart' as _i409;
import '../../features/movies/domain/usecases/get_similar_movies_usecase.dart'
    as _i654;
import '../../features/movies/presentation/manager/movies_cubit.dart' as _i366;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/presentation/manager/profile_cubit.dart'
    as _i735;
import '../../features/search/presentation/manager/search_cubit.dart' as _i827;
import '../../features/splash/presentation/manager/splash_cubit.dart' as _i478;
import '../../features/wishlist/data/data_sources/wishlist_local_data_source.dart'
    as _i397;
import '../../features/wishlist/data/data_sources/wishlist_local_data_source_impl.dart'
    as _i719;
import '../../features/wishlist/data/data_sources/wishlist_remote_data_source.dart'
    as _i655;
import '../../features/wishlist/data/data_sources/wishlist_remote_data_source_impl.dart'
    as _i810;
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart'
    as _i919;
import '../../features/wishlist/domain/repositories/wishlist_repository.dart'
    as _i4;
import '../../features/wishlist/domain/usecases/add_to_wishlist_usecase.dart'
    as _i74;
import '../../features/wishlist/domain/usecases/get_wishlist_usecase.dart'
    as _i1065;
import '../../features/wishlist/domain/usecases/is_in_wishlist_usecase.dart'
    as _i782;
import '../../features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart'
    as _i120;
import '../../features/wishlist/presentation/manager/wishlist_cubit.dart'
    as _i546;
import '../network/api_service.dart' as _i921;
import 'firebase_module.dart' as _i616;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i478.SplashCubit>(() => _i478.SplashCubit());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.auth);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i828.HistoryLocalDataSource>(
        () => _i21.HistoryLocalDataSourceImpl());
    gh.lazySingleton<_i787.AuthRepository>(
        () => _i900.FirebaseAuthRepository());
    gh.lazySingleton<_i900.BrowseLocalDataSource>(
        () => _i900.BrowseLocalDataSourceImpl());
    gh.lazySingleton<_i397.WishlistLocalDataSource>(
        () => _i719.WishlistLocalDataSourceImpl());
    gh.lazySingleton<_i556.MovieLocalDataSource>(
        () => _i556.MovieLocalDataSourceImpl());
    gh.lazySingleton<_i921.ApiService>(() => _i921.ApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i404.MovieRemoteDataSource>(
        () => _i404.MovieRemoteDataSourceImpl(gh<_i921.ApiService>()));
    gh.lazySingleton<_i828.HistoryRemoteDataSource>(
        () => _i343.HistoryRemoteDataSourceImpl(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
            ));
    gh.lazySingleton<_i894.ProfileRepository>(() => _i334.ProfileRepositoryImpl(
          gh<_i974.FirebaseFirestore>(),
          gh<_i59.FirebaseAuth>(),
        ));
    gh.lazySingleton<_i655.WishlistRemoteDataSource>(
        () => _i810.WishlistRemoteDataSourceImpl(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
            ));
    gh.factory<_i957.LogInUseCase>(
        () => _i957.LogInUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i169.ResetPasswordUseCase>(
        () => _i169.ResetPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i247.SignInWithGoogleUseCase>(
        () => _i247.SignInWithGoogleUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i131.SignOutUseCase>(
        () => _i131.SignOutUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i179.SignUpUseCase>(
        () => _i179.SignUpUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i735.ProfileCubit>(() => _i735.ProfileCubit(
          gh<_i894.ProfileRepository>(),
          gh<_i59.FirebaseAuth>(),
        ));
    gh.lazySingleton<_i887.BrowseRemoteDataSource>(
        () => _i887.BrowseRemoteDataSourceImpl(gh<_i921.ApiService>()));
    gh.lazySingleton<_i221.BrowseRepository>(() => _i791.BrowseRepositoryImpl(
          remoteDataSource: gh<_i887.BrowseRemoteDataSource>(),
          localDataSource: gh<_i900.BrowseLocalDataSource>(),
        ));
    gh.lazySingleton<_i465.MovieRepository>(() => _i652.MovieRepositoryImpl(
          gh<_i404.MovieRemoteDataSource>(),
          gh<_i556.MovieLocalDataSource>(),
        ));
    gh.lazySingleton<_i276.GetMoviesByGenreUseCase>(
        () => _i276.GetMoviesByGenreUseCase(gh<_i221.BrowseRepository>()));
    gh.lazySingleton<_i142.HistoryRepository>(() => _i751.HistoryRepositoryImpl(
          remoteDataSource: gh<_i828.HistoryRemoteDataSource>(),
          localDataSource: gh<_i828.HistoryLocalDataSource>(),
        ));
    gh.lazySingleton<_i409.GetMoviesUseCase>(
        () => _i409.GetMoviesUseCase(gh<_i465.MovieRepository>()));
    gh.lazySingleton<_i237.GetMovieDetailsUseCase>(
        () => _i237.GetMovieDetailsUseCase(gh<_i465.MovieRepository>()));
    gh.factory<_i654.GetSimilarMoviesUseCase>(
        () => _i654.GetSimilarMoviesUseCase(gh<_i465.MovieRepository>()));
    gh.lazySingleton<_i962.AddToHistoryUseCase>(
        () => _i962.AddToHistoryUseCase(gh<_i142.HistoryRepository>()));
    gh.lazySingleton<_i840.GetHistoryUseCase>(
        () => _i840.GetHistoryUseCase(gh<_i142.HistoryRepository>()));
    gh.factory<_i117.AuthCubit>(() => _i117.AuthCubit(
          signUpUseCase: gh<_i179.SignUpUseCase>(),
          logInUseCase: gh<_i957.LogInUseCase>(),
          signOutUseCase: gh<_i131.SignOutUseCase>(),
          resetPasswordUseCase: gh<_i169.ResetPasswordUseCase>(),
          signInWithGoogleUseCase: gh<_i247.SignInWithGoogleUseCase>(),
        ));
    gh.lazySingleton<_i4.WishlistRepository>(() => _i919.WishlistRepositoryImpl(
          remoteDataSource: gh<_i655.WishlistRemoteDataSource>(),
          localDataSource: gh<_i397.WishlistLocalDataSource>(),
        ));
    gh.lazySingleton<_i74.AddToWishlistUseCase>(
        () => _i74.AddToWishlistUseCase(gh<_i4.WishlistRepository>()));
    gh.lazySingleton<_i1065.GetWishlistUseCase>(
        () => _i1065.GetWishlistUseCase(gh<_i4.WishlistRepository>()));
    gh.lazySingleton<_i782.IsInWishlistUseCase>(
        () => _i782.IsInWishlistUseCase(gh<_i4.WishlistRepository>()));
    gh.lazySingleton<_i120.RemoveFromWishlistUseCase>(
        () => _i120.RemoveFromWishlistUseCase(gh<_i4.WishlistRepository>()));
    gh.factory<_i269.MovieDetailsCubit>(() => _i269.MovieDetailsCubit(
          gh<_i237.GetMovieDetailsUseCase>(),
          gh<_i654.GetSimilarMoviesUseCase>(),
        ));
    gh.lazySingleton<_i154.HistoryCubit>(() => _i154.HistoryCubit(
          addToHistoryUseCase: gh<_i962.AddToHistoryUseCase>(),
          getHistoryUseCase: gh<_i840.GetHistoryUseCase>(),
        ));
    gh.factory<_i259.BrowseCubit>(
        () => _i259.BrowseCubit(gh<_i276.GetMoviesByGenreUseCase>()));
    gh.factory<_i366.MoviesCubit>(
        () => _i366.MoviesCubit(gh<_i409.GetMoviesUseCase>()));
    gh.factory<_i827.SearchCubit>(
        () => _i827.SearchCubit(gh<_i465.MovieRepository>()));
    gh.lazySingleton<_i546.WishlistCubit>(() => _i546.WishlistCubit(
          addToWishlistUseCase: gh<_i74.AddToWishlistUseCase>(),
          removeFromWishlistUseCase: gh<_i120.RemoveFromWishlistUseCase>(),
          getWishlistUseCase: gh<_i1065.GetWishlistUseCase>(),
          isInWishlistUseCase: gh<_i782.IsInWishlistUseCase>(),
        ));
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}

class _$NetworkModule extends _i921.NetworkModule {}
