import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../view_models/forget_password_view_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../../domain/repositories/auth_repository.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordViewModel(authRepository: authRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('forget_password'.tr(), style: TextStyle(color: Theme.of(context).primaryColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Consumer<ForgetPasswordViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Illustration Placeholder
                    const SizedBox(
                      height: 250,
                      child: Center(
                        child: Icon(Icons.image, size: 100, color: Colors.white54), // Placeholder for actual illustration
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    CustomTextField(
                      controller: emailController,
                      hintText: 'email'.tr(),
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),

                    // Verify Button
                    viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                          text: 'verify_email'.tr(),
                          onPressed: () => viewModel.verifyEmail(emailController.text),
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
