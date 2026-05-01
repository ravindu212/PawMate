import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- 1. Import Riverpod
import 'package:google_fonts/google_fonts.dart';
import 'ui/screens/main_screen.dart';
import 'providers/theme_provider.dart'; // <-- 2. Import the provider

// 3. Change to ConsumerWidget
class PawMateApp extends ConsumerWidget {
  const PawMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. Watch the theme provider!
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'PawMate',
      debugShowCheckedModeBanner: false,
      
      // 5. This tells Flutter to switch based on our true/false value
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, 
      
      // --- LIGHT THEME SETTINGS ---
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light, 
        ),
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
        useMaterial3: true,
      ),
      
      // --- DARK THEME SETTINGS ---
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark, 
        ),
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}