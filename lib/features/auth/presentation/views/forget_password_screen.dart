import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movies/features/auth/presentation/widgets/primary_button.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/auth/presentation/cubits/forget_password_cubit.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authRepository = RepositoryProvider.of<AuthRepository>(context);

    return BlocProvider(
      create: (_) => ForgetPasswordCubit(authRepository: authRepository),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'forget_password'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC107)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
              listener: (context, state) {
                if (state is ForgetPasswordSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Verification email sent to ${emailController.text}',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is ForgetPasswordFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final cubit = context.read<ForgetPasswordCubit>();
                final isLoading = state is ForgetPasswordLoading;

                return Column(
                  children: [
                    Image.asset(
                      'assets/images/forgot_password.png',
                      height: 200,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.lock_reset,
                        size: 100,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'email'.tr(),
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 40),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'verify_email'.tr(),
                            onPressed: () =>
                                cubit.sendResetEmail(emailController.text),
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
