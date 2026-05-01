import 'package:flutter/material.dart';
import '../../../data/models/pet.dart';
import 'weight_tracker_screen.dart';
import 'health_records_screen.dart';

class PetDetailsScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailsScreen({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${pet.name}\'s Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Pet Info Card ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(
                        pet.species == 'Dog'
                            ? Icons.pets
                            : pet.species == 'Cat'
                            ? Icons.cruelty_free
                            : Icons.eco,
                        size: 50,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Displaying your dynamic age string!
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pet.age,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Species', pet.species),
                    if (pet.breed != null) _buildInfoRow('Breed', pet.breed!),
                    if (pet.motherBreed != null)
                      _buildInfoRow('Mother', pet.motherBreed!),
                    if (pet.fatherBreed != null)
                      _buildInfoRow('Father', pet.fatherBreed!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Weight Tracker Button ---
            const Text(
              'Health & Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildActionCard(
              context,
              title: 'Weight Tracker',
              subtitle: 'Monitor growth and diet',
              icon: Icons.monitor_weight,
              color: Colors.blueAccent,
              onTap: () {
                // This is the door to your chart!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeightTrackerScreen(pet: pet),
                  ),
                );
              },
            ),
            // --- The new Health Records Button ---
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              title: 'Health & Vaccines',
              subtitle: 'Medical history and due dates',
              icon: Icons.health_and_safety,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthRecordsScreen(pet: pet),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the text rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Helper for the big action buttons
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
