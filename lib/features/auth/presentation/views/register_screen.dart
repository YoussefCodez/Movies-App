import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/core/services/get_it.dart';
import 'package:movies/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:movies/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movies/features/auth/presentation/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(signUpUseCase: getIt<SignUpUseCase>()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'register'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC107)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is SignUpSuccess) {
                  Navigator.pushReplacementNamed(context, '/main');
                } else if (state is SignUpError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final cubit = context.read<AuthCubit>();
                final isLoading = state is SignUpLoading;

                return Column(
                  children: [
                    // Avatar Selection
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        itemCount: avatars.length,
                        // onPageChanged: (index) =>
                        //     cubit.selectAvatar(avatars[index]),
                        itemBuilder: (context, index) {
                          return Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(avatars[index]),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'choose_avatar'.tr(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'name'.tr(),
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),
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
                      obscureText: false,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 40),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'create_account'.tr(),
                            onPressed: () => cubit.signUpWithEmail(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          ),
                    const SizedBox(height: 24),
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
