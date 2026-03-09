import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/auth/presentation/view_models/register_view_model.dart';
import 'package:movies/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movies/features/auth/presentation/widgets/primary_button.dart';
import 'package:movies/features/auth/presentation/widgets/language_toggle.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<String> avatars = [
    'assets/images/user1.png',
    'assets/images/user2.png',
    'assets/images/user3.png',
  ];

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(authRepository: authRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'register'.tr(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.yellow,
            ), // Matches primary
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Consumer<RegisterViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(avatars.length, (index) {
                          bool isSelected =
                              viewModel.selectedAvatarIndex == index;
                          return GestureDetector(
                            onTap: () => viewModel.selectAvatar(index),
                            child: CircleAvatar(
                              radius: isSelected ? 50 : 35,
                              backgroundColor: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              // backgroundImage: AssetImage(avatars[index]),
                              child: Icon(
                                Icons.person,
                                size: isSelected ? 60 : 40,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Avatar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Inputs
                    CustomTextField(
                      controller: nameController,
                      hintText: 'name'.tr(),
                      prefixIcon: Icons.badge,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'email'.tr(),
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: confirmPasswordController,
                      hintText: 'confirm_password'.tr(),
                      prefixIcon: Icons.lock,
                      obscureText: !viewModel.isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: viewModel.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'phone_number'.tr(),
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'create_account'.tr(),
                            onPressed: () => viewModel.register(
                              context,
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              phoneController.text,
                            ),
                          ),
                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already_have_account'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pop(context), // Pops back to Login
                          child: Text(
                            'login'.tr(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

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
