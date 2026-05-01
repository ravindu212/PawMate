import 'package:flutter/material.dart';
import '../pets/pet_list_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PawMate')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.pets),
          label: const Text('My Pets'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PetListScreen()),
          ),
        ),
      ),
    );
  }
}