import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/auth/presentation/view_models/login_view_model.dart';
import 'package:movies/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movies/features/auth/presentation/widgets/primary_button.dart';
import 'package:movies/features/auth/presentation/widgets/social_button.dart';
import 'package:movies/features/auth/presentation/widgets/language_toggle.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    // Use ChangeNotifierProvider inside the route configuration or here per screen
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(authRepository: authRepository),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Play Logo
                    Icon(
                      Icons.play_circle_outline,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 50),

                    // Email Field
                    CustomTextField(
                      controller: emailController,
                      hintText: 'email'.tr(),
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'password'.tr(),
                      prefixIcon: Icons.lock,
                      obscureText: !viewModel.isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: viewModel.togglePasswordVisibility,
                      ),
                    ),

                    // Forget Password Text
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

                    // Login Button
                    viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'login'.tr(),
                            onPressed: () => viewModel.loginWithEmail(
                              emailController.text,
                              passwordController.text,
                            ),
                          ),
                    const SizedBox(height: 24),

                    // Create Account Link
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

                    // OR Divider
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

                    // Google Login Button
                    SocialButton(
                      text: 'login_with_google'.tr(),
                      onPressed: viewModel.loginWithGoogle,
                    ),
                    const SizedBox(height: 48),

                    // Language Toggle
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
