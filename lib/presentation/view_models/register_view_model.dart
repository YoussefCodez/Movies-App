import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  RegisterViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  int _selectedAvatarIndex = 1; // Default to middle avatar

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isLoading => _isLoading;
  int get selectedAvatarIndex => _selectedAvatarIndex;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void selectAvatar(int index) {
    _selectedAvatarIndex = index;
    notifyListeners();
  }

  Future<void> register(BuildContext context, String name, String email, String password, String phone) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.signUpWithEmail(email, password, name);
      
      // Navigate back to login or home
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Registration Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
