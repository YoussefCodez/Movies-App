import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> initSplash(BuildContext context) async {
    // Simulate loading data or initializing Firebase/Auth state
    await Future.delayed(const Duration(seconds: 3));
    
    // Default routing to Login screen after splash.
    // Ensure the Navigator can find this route.
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }
}
