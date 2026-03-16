import 'package:flutter/material.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

class ForgetPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ForgetPasswordViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> verifyEmail(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      debugPrint('Reset Password Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
