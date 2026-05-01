import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/pet_provider.dart';
import 'add_pet_screen.dart';
import 'pet_details_screen.dart'; // <-- 1. Import the details screen!

class PetListScreen extends ConsumerWidget {
  const PetListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pets = ref.watch(petProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My PawMates'),
      ),
      body: pets.isEmpty
          ? const Center(child: Text('No pets added yet!'))
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(
                        pet.species == 'Dog' ? Icons.pets : 
                        pet.species == 'Cat' ? Icons.cruelty_free : Icons.eco, 
                        color: Colors.teal,
                      ),
                    ),
                    title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(pet.species),
                    trailing: const Icon(Icons.chevron_right),
                    
                    // --- THE DOORWAY TO THE PROFILE AND WEIGHT TRACKER ---
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailsScreen(pet: pet),
                        ),
                      );
                    },
                    
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPetScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}