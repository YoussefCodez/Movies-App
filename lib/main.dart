import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/cubits/theme_cubit.dart';

// Repository
import 'features/auth/domain/repositories/auth_repository.dart';

// Screens
import 'features/splash/presentation/views/splash_screen.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/auth/presentation/views/register_screen.dart';
import 'features/auth/presentation/views/forget_password_screen.dart';
import 'features/main/presentation/views/main_layout_screen.dart';

import 'package:movies/core/services/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: RepositoryProvider<AuthRepository>(
        // بنستخدم getIt عشان نجيب نسخة الـ AuthRepository اللي اتسجلت
        create: (_) => getIt<AuthRepository>(),
        child: MultiBlocProvider(
          providers: [BlocProvider(create: (_) => ThemeCubit())],
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
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movies App',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/forget_password': (context) => ForgetPasswordScreen(),
            '/main': (context) => const MainLayoutScreen(),
          },
        );
      },
    );
  }
}
