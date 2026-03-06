import 'package:flutter/material.dart';

// Note: easy_localization largely handles its own persistence and state.
// This provider can act as a bridge if you want custom logic or simplified UI toggles.
class LanguageProvider extends ChangeNotifier {
  // Locale will be directly managed by context.setLocale() from easy_localization
  // This class can be expanded if additional language-related state is needed.
}
