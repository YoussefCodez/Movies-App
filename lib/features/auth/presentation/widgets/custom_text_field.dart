import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller; // Changed to be required
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon, // No longer required
    this.obscureText = false,
    this.suffixIcon,
    required this.controller, // Now required
    this.validator,
    this.keyboardType = TextInputType.text, // Retain default value
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white), // or adapt via theme
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Theme.of(context).primaryColor) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
