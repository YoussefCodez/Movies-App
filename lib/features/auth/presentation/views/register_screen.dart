import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movies/features/auth/presentation/widgets/primary_button.dart';
import 'package:movies/features/auth/presentation/widgets/language_toggle.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<String> avatars = [
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

  int selectedAvatarIndex = 0;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  PageController? _avatarPageController;

  @override
  void initState() {
    super.initState();
    _initAvatar();
  }

  Future<void> _initAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('selected_avatar_index');

    if (savedIndex == null) {
      savedIndex = Random().nextInt(avatars.length);
      await prefs.setInt('selected_avatar_index', savedIndex);
    }

    if (mounted) {
      setState(() {
        selectedAvatarIndex = savedIndex!;
        _avatarPageController = PageController(
          viewportFraction: 0.35,
          initialPage: selectedAvatarIndex,
        );
      });
    }
  }

  @override
  void dispose() {
    _avatarPageController?.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'register'.tr(),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              Navigator.pushReplacementNamed(context, '/main');
            } else if (state is SignUpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar Selection
                  SizedBox(
                    height:
                        140, // Height slightly increased to accommodate scaling
                    child: _avatarPageController == null
                        ? const Center(child: CircularProgressIndicator())
                        : PageView.builder(
                            controller: _avatarPageController,
                            itemCount: avatars.length,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (index) async {
                              setState(() {
                                selectedAvatarIndex = index;
                              });
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setInt(
                                'selected_avatar_index',
                                index,
                              );
                            },
                            itemBuilder: (context, index) {
                              bool isSelected = selectedAvatarIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  // If they tap an avatar, animate nicely to it
                                  _avatarPageController?.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutBack,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: AnimatedScale(
                                    scale: isSelected
                                        ? 1.15
                                        : 0.75, // Central item is larger
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutBack,
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset(
                                        avatars[index],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                    obscureText: !isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: 'confirm_password'.tr(),
                    prefixIcon: Icons.lock,
                    obscureText: !isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
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
                  state is SignUpLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                          text: 'create_account'.tr(),
                          onPressed: () {
                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please fill all required fields',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<AuthCubit>().signUpWithEmail(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              name: nameController.text.trim(),
                            );
                          },
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
              ),
            );
          },
        ),
      ),
    );
  }
}
