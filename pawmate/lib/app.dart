import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // <-- Import Google Fonts
import 'ui/screens/main_screen.dart';

class PawMateApp extends StatelessWidget {
  const PawMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 1. The Color Palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          secondary: Colors.orangeAccent,
        ),
        
        // 2. The Custom Font (Nunito looks very friendly and modern)
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        
        // 3. App Bar Styling (Flat and centered)
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0, 
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white, // Text color on the AppBar
        ),

        // 4. Floating Action Button Styling
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
        ),
        
        useMaterial3: true, // Uses Flutter's newest modern design system
      ),
      home: const MainScreen(),
    );
  }
}