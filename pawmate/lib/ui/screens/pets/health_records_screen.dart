import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/pet.dart';
import '../../../providers/health_provider.dart';

class HealthRecordsScreen extends ConsumerStatefulWidget {
  final Pet pet;

  const HealthRecordsScreen({Key? key, required this.pet}) : super(key: key);

  @override
  ConsumerState<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends ConsumerState<HealthRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Smart Dictionaries
  final List<String> _dogVaccines = ['Rabies', 'DHPP (Distemper/Parvo)', 'Bordetella', 'Leptospirosis', 'Lyme Disease', 'Canine Influenza'];
  final List<String> _catVaccines = ['Rabies', 'FVRCP', 'Feline Leukemia (FeLV)', 'Bordetella', 'FIP'];
  final List<String> _commonMeds = ['Flea & Tick Prevention', 'Heartworm Prevention', 'Dewormer'];

  final List<String> _categories = ['Vaccination', 'Checkup', 'Medication', 'Surgery'];

  void _showAddRecordDialog() {
    String selectedCategory = 'Vaccination';
    String title = '';
    String notes = '';
    DateTime selectedDate = DateTime.now();
    DateTime? nextDueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<String> suggestions = [];
            if (selectedCategory == 'Vaccination') {
              suggestions = widget.pet.species == 'Dog' ? _dogVaccines : (widget.pet.species == 'Cat' ? _catVaccines : []);
            } else if (selectedCategory == 'Medication') {
              suggestions = _commonMeds;
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24,),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Add Health Record', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      
                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) => setState(() { selectedCategory = val!; title = ''; }), // Reset title on category change
                      ),
                      const SizedBox(height: 16),

                      // Smart Autocomplete Title
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty && suggestions.isNotEmpty) return suggestions;
                          return suggestions.where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (selection) => title = selection,
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: selectedCategory == 'Checkup' ? 'Reason for Visit' : 'Name of $selectedCategory',
                              border: const OutlineInputBorder(),
                              helperText: suggestions.isNotEmpty ? 'Start typing for suggestions' : null,
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                            onChanged: (val) => title = val,
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date Given
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Date Administered'),
                        subtitle: Text(DateFormat.yMMMd().format(selectedDate), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime.now());
                          if (picked != null) setState(() => selectedDate = picked);
                        },
                      ),

                      // Next Due Date (Optional)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Next Due Date (Optional)'),
                        subtitle: Text(nextDueDate == null ? 'Not set' : DateFormat.yMMMd().format(nextDueDate!), style: TextStyle(fontWeight: FontWeight.bold, color: nextDueDate == null ? Colors.grey : Colors.orange)),
                        trailing: const Icon(Icons.alarm_add),
                        onTap: () async {
                          final picked = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 365)), firstDate: DateTime.now(), lastDate: DateTime(2100));
                          if (picked != null) setState(() => nextDueDate = picked);
                        },
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: Colors.teal, foregroundColor: Colors.white),
                        onPressed: () {
                          if (_formKey.currentState!.validate() && title.isNotEmpty) {
                            ref.read(healthProvider(widget.pet.id).notifier).addRecord(
                              title: title, category: selectedCategory, date: selectedDate, nextDueDate: nextDueDate, notes: notes,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save Record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  // Visual Helper for Icons & Colors
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Vaccination': return Icons.vaccines;
      case 'Checkup': return Icons.medical_services;
      case 'Medication': return Icons.medication;
      case 'Surgery': return Icons.local_hospital;
      default: return Icons.healing;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Vaccination': return Colors.blueAccent;
      case 'Checkup': return Colors.teal;
      case 'Medication': return Colors.orange;
      case 'Surgery': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(healthProvider(widget.pet.id));

    return Scaffold(
      appBar: AppBar(title: Text('${widget.pet.name}\'s Health'), centerTitle: true),
      body: records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.health_and_safety_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('No health records yet!', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final color = _getCategoryColor(record.category);
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                          child: Icon(_getCategoryIcon(record.category), color: color, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(record.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(record.category, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.event_available, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('Given: ${DateFormat.yMMMd().format(record.date)}', style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                              if (record.nextDueDate != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.alarm, size: 16, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text('Next Due: ${DateFormat.yMMMd().format(record.nextDueDate!)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => ref.read(healthProvider(widget.pet.id).notifier).deleteRecord(record.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRecordDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}