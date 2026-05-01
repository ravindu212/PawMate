import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/pet.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../providers/pet_provider.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  String _selectedSpecies = 'Dog';
  PetGender _selectedGender = PetGender.male;
  DateTime _dateOfBirth = DateTime.now();

  final _species = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Fish', 'Other'];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _savePet() async {
    if (_nameController.text.trim().isEmpty) return;

    final pet = Pet()
      ..name = _nameController.text.trim()
      ..species = _selectedSpecies
      ..breed = _breedController.text.trim()
      ..dateOfBirth = _dateOfBirth
      ..gender = _selectedGender;

    await ref.read(petRepositoryProvider).addPet(pet);
    ref.invalidate(petsProvider);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
        actions: [
          TextButton(
            onPressed: _savePet,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Name
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Pet Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Species
          DropdownButtonFormField<String>(
            value: _selectedSpecies,
            decoration: const InputDecoration(
              labelText: 'Species',
              border: OutlineInputBorder(),
            ),
            items: _species
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _selectedSpecies = v!),
          ),
          const SizedBox(height: 16),

          // Breed
          TextField(
            controller: _breedController,
            decoration: const InputDecoration(
              labelText: 'Breed',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Gender
          const Text('Gender', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<PetGender>(
            segments: const [
              ButtonSegment(value: PetGender.male, label: Text('Male')),
              ButtonSegment(value: PetGender.female, label: Text('Female')),
              ButtonSegment(value: PetGender.unknown, label: Text('Unknown')),
            ],
            selected: {_selectedGender},
            onSelectionChanged: (v) =>
                setState(() => _selectedGender = v.first),
          ),
          const SizedBox(height: 16),

          // Date of Birth
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            title: const Text('Date of Birth'),
            subtitle: Text(
              '${_dateOfBirth.day}/${_dateOfBirth.month}/${_dateOfBirth.year}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
        ],
      ),
    );
  }
}