import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/pet_provider.dart';
import 'add_pet_screen.dart';
import 'health_records_screen.dart';

// 1. Change StatelessWidget to ConsumerWidget
class PetListScreen extends ConsumerWidget {
  const PetListScreen({Key? key}) : super(key: key);

  // 2. Add 'WidgetRef ref' to the build method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Watch the provider! This single line grabs the list of pets.
    // If a pet is added or deleted, Riverpod automatically redraws this screen.
    final pets = ref.watch(petProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My PawMates')),
      body: pets.isEmpty
          ? const Center(
              child: Text(
                'No pets yet. Tap + to add one!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index]; // Get the current pet

                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.pets), // A temporary placeholder icon
                  ),
                  title: Text(pet.name),
                  subtitle: Text('${pet.species} • Age: ${pet.age ?? '?'}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Pass the clicked pet directly into the new screen!
                        builder: (context) => HealthRecordsScreen(pet: pet),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // 4. Use ref.read to perform an ACTION (like deleting)
                      ref.read(petProvider.notifier).deletePet(pet.id);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
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
