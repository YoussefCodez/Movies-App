import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/di/injection_container.dart';
import 'features/splash/presentation/views/splash_screen.dart';
import 'features/splash/presentation/manager/splash_cubit.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/auth/presentation/views/register_screen.dart';
import 'features/auth/presentation/views/forget_password_screen.dart';
import 'features/main/presentation/views/main_layout_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/movies/domain/entities/movie_entity.dart';
import 'features/movie_details/presentation/views/movie_details_screen.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'features/history/presentation/manager/history_cubit.dart';
import 'features/profile/presentation/manager/profile_cubit.dart';
import 'features/browse/presentation/cubit/browse_cubit.dart';
import 'features/browse/data/datasources/browse_local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MovieEntityAdapter());
  Hive.registerAdapter(CastEntityAdapter());

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  configureDependencies();

  await getIt<BrowseLocalDataSource>().clearCache();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<AuthCubit>()),
            BlocProvider(create: (context) => getIt<WishlistCubit>()),
            BlocProvider(create: (context) => getIt<HistoryCubit>()),
            BlocProvider(create: (context) => getIt<SplashCubit>()),
            BlocProvider(
              create: (context) => getIt<ProfileCubit>()..loadProfile(),
            ),
            BlocProvider(create: (context) => getIt<BrowseCubit>()),
          ],
          child: const MovieApp(),
        ),
      ),
    ),
  );
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forget_password': (context) => ForgetPasswordScreen(),
        '/main': (context) => const MainLayoutScreen(),
        '/movie-details': (context) => const MovieDetailsScreen(),
      },
    );
  }
}
