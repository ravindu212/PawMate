import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/today/today_screen.dart';

class PawMateApp extends StatelessWidget {
  const PawMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: TodayScreen(),  
    );
  }
}