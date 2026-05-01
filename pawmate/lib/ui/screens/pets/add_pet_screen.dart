import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Needed to format the date nicely
import '../../../providers/pet_provider.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  
  DateTime? _selectedDateOfBirth;
  String? _selectedSpecies;
  String? _selectedBreed;
  String? _motherBreed;
  String? _fatherBreed;

  // Offline Dictionaries
  final List<String> _speciesList = [
    'Dog', 'Cat', 'Fish', 'Bird', 'Rabbit', 'Hamster', 'Guinea Pig', 
    'Turtle', 'Snake', 'Lizard', 'Ferret', 'Mouse', 'Rat', 'Horse', 'Pig'
  ];

  final List<String> _dogBreeds = [
    'Labrador Retriever', 'German Shepherd', 'Golden Retriever', 'French Bulldog', 
    'Bulldog', 'Poodle', 'Beagle', 'Rottweiler', 'German Shorthaired Pointer', 
    'Dachshund', 'Pembroke Welsh Corgi', 'Australian Shepherd', 'Yorkshire Terrier', 
    'Boxer', 'Cavalier King Charles Spaniel', 'Doberman Pinscher', 'Great Dane', 
    'Miniature Schnauzer', 'Siberian Husky', 'Bernese Mountain Dog', 'Shih Tzu', 
    'Boston Terrier', 'Pomeranian', 'Havanese',"Ridgeback", 'Pug', 'Chihuahua', 'Mixed Breed'
  ];

  // Helper widget for Autocomplete
  Widget _buildBreedAutocomplete({
    required String label,
    required IconData icon,
    required Function(String) onSelected,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.length < 3) return const Iterable<String>.empty();
        return _dogBreeds.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.teal),
            helperText: 'Type at least 3 letters to search',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          onChanged: (val) => onSelected(val), 
        );
      },
    );
  }

  // Opens the Calendar Picker
  Future<void> _pickDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990), // How far back they can scroll
      lastDate: DateTime.now(), // Can't pick a date in the future
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal, // Selection color
              onPrimary: Colors.white, // Text color on selection
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a Date of Birth!')),
        );
        return;
      }

      ref.read(petProvider.notifier).addPet(
        name: _nameController.text,
        species: _selectedSpecies!,
        dateOfBirth: _selectedDateOfBirth!,
        breed: _selectedSpecies == 'Dog' ? _selectedBreed : null,
        motherBreed: _selectedBreed == 'Mixed Breed' ? _motherBreed : null,
        fatherBreed: _selectedBreed == 'Mixed Breed' ? _fatherBreed : null,
      );
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDog = _selectedSpecies == 'Dog';
    bool isMixedBreed = _selectedBreed == 'Mixed Breed';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a PawMate', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- CARD 1: BASIC INFO ---
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Pet Name',
                          prefixIcon: const Icon(Icons.badge, color: Colors.teal),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                      ),
                      const SizedBox(height: 16),

                      // Beautiful interactive Date Picker field
                      InkWell(
                        onTap: _pickDateOfBirth,
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: const Icon(Icons.cake, color: Colors.teal),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            errorText: _selectedDateOfBirth == null ? 'Required' : null,
                          ),
                          child: Text(
                            _selectedDateOfBirth == null 
                                ? 'Tap to select date' 
                                : DateFormat.yMMMd().format(_selectedDateOfBirth!),
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedDateOfBirth == null ? Colors.grey.shade600 : Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Species',
                          prefixIcon: const Icon(Icons.pets, color: Colors.teal),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        value: _selectedSpecies,
                        items: _speciesList.map((species) {
                          return DropdownMenuItem(value: species, child: Text(species));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSpecies = value;
                            _selectedBreed = null; 
                            _motherBreed = null;
                            _fatherBreed = null;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a species' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- CARD 2: BREED DETAILS (Conditionally shown) ---
              if (isDog) 
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Breed Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                        const SizedBox(height: 16),
                        
                        _buildBreedAutocomplete(
                          label: 'Dog Breed',
                          icon: Icons.auto_awesome,
                          onSelected: (selection) {
                            setState(() {
                              _selectedBreed = selection;
                              if (selection != 'Mixed Breed') {
                                _motherBreed = null;
                                _fatherBreed = null;
                              }
                            });
                          },
                        ),
                        
                        if (isMixedBreed) ...[
                          const SizedBox(height: 24),
                          const Text('Parent Breeds (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _buildBreedAutocomplete(
                            label: "Mother's Breed",
                            icon: Icons.female,
                            onSelected: (selection) => _motherBreed = selection,
                          ),
                          const SizedBox(height: 16),
                          _buildBreedAutocomplete(
                            label: "Father's Breed",
                            icon: Icons.male,
                            onSelected: (selection) => _fatherBreed = selection,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),

              // --- SAVE BUTTON ---
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('Save Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
                onPressed: _savePet,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}