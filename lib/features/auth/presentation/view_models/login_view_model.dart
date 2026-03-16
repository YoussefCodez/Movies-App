import 'package:flutter/material.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;


  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }


  Future<void> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.signInWithEmail(email, password);
    } catch (e) {
      debugPrint('Login Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
