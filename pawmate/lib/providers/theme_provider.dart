import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple state provider that holds a boolean (true/false)
// false = Light Mode, true = Dark Mode
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // App starts in light mode by default

  void toggleTheme() {
    state = !state; // Flips true to false, or false to true
  }
}

// The provider we will use to watch this state
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});