import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/pet.dart';
import '../../../providers/pet_provider.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  // These controllers grab the text from the text fields
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _ageController = TextEditingController();

  // Clean up the controllers when the screen closes to save memory
  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _savePet() {
    // 1. Grab the text from the controllers
    final name = _nameController.text.trim();
    final species = _speciesController.text.trim();
    final ageText = _ageController.text.trim();

    // 2. Simple validation: Make sure name and species aren't empty
    if (name.isEmpty || species.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name and species')),
      );
      return;
    }

    // 3. Create the new Pet object
    final newPet = Pet(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Generates a unique ID
      name: name,
      species: species,
      age: int.tryParse(ageText), // Converts the text to a number safely
    );

    // 4. Save the pet using our Riverpod Provider!
    ref.read(petProvider.notifier).addPet(newPet);

    // 5. Go back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a PawMate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Pet Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _speciesController,
              decoration: const InputDecoration(
                labelText: 'Species (e.g., Dog, Cat)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number, // Shows the number keyboard
              decoration: const InputDecoration(
                labelText: 'Age (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, // Makes the button stretch full width
              height: 50,
              child: ElevatedButton(
                onPressed: _savePet,
                child: const Text('Save Pet', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}