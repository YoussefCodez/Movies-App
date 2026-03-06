import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movies/features/auth/presentation/widgets/primary_button.dart';
import 'package:movies/features/auth/presentation/widgets/social_button.dart';
import 'package:movies/features/auth/presentation/widgets/language_toggle.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/auth/presentation/cubits/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';
    final authRepository = RepositoryProvider.of<AuthRepository>(context);

    return BlocProvider(
      create: (_) => LoginCubit(authRepository: authRepository),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushReplacementNamed(context, '/main');
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final cubit = context.read<LoginCubit>();
                final isLoading = state is LoginLoading;
                final isPasswordVisible = cubit.isPasswordVisible;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'email'.tr(),
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'password'.tr(),
                      prefixIcon: Icons.lock,
                      obscureText: !isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: cubit.togglePasswordVisibility,
                      ),
                    ),
                    Align(
                      alignment: isArabic
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/forget_password'),
                        child: Text(
                          'forget_password'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'login'.tr(),
                            onPressed: () => cubit.loginWithEmail(
                              emailController.text,
                              passwordController.text,
                            ),
                          ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'dont_have_account'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: Text(
                            'create_one'.tr(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.white24, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.white24, thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SocialButton(
                      text: 'login_with_google'.tr(),
                      onPressed: cubit.loginWithGoogle,
                    ),
                    const SizedBox(height: 48),
                    const Align(
                      alignment: Alignment.center,
                      child: LanguageToggle(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
