import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/pet.dart';
import '../../../providers/routine_provider.dart';

class RoutineScreen extends ConsumerStatefulWidget {
  final Pet pet;

  const RoutineScreen({Key? key, required this.pet}) : super(key: key);

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _categories = ['Food', 'Walk', 'Meds', 'Potty', 'Grooming', 'Other'];

  void _showAddRoutineDialog() {
    String selectedCategory = 'Food';
    String title = '';
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24,),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Add Daily Routine', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      
                      // Category
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) => setState(() => selectedCategory = val!),
                      ),
                      const SizedBox(height: 16),

                      // Task Title
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Task (e.g., Morning Walk)', border: OutlineInputBorder()),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        onChanged: (val) => title = val,
                      ),
                      const SizedBox(height: 16),

                      // Time Picker
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Time of Day'),
                        subtitle: Text(selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 16)),
                        trailing: const Icon(Icons.access_time),
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: selectedTime);
                          if (picked != null) setState(() => selectedTime = picked);
                        },
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: Colors.teal, foregroundColor: Colors.white),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Convert TimeOfDay to DateTime for storage
                            final now = DateTime.now();
                            final scheduledTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
                            
                            ref.read(routineProvider(widget.pet.id).notifier).addRoutine(
                              title: title, time: scheduledTime, category: selectedCategory,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save Routine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.restaurant;
      case 'Walk': return Icons.directions_walk;
      case 'Meds': return Icons.medication;
      case 'Potty': return Icons.grass;
      case 'Grooming': return Icons.dry_cleaning;
      default: return Icons.task_alt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routines = ref.watch(routineProvider(widget.pet.id));

    return Scaffold(
      appBar: AppBar(title: Text('${widget.pet.name}\'s Routine'), centerTitle: true),
      body: routines.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('No routines set yet!', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: routines.length,
              itemBuilder: (context, index) {
                final routine = routines[index];
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade50,
                      child: Icon(_getCategoryIcon(routine.category), color: Colors.teal),
                    ),
                    title: Text(routine.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(routine.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(DateFormat.jm().format(routine.time), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => ref.read(routineProvider(widget.pet.id).notifier).deleteRoutine(routine.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRoutineDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}