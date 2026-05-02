import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/pet_provider.dart';
import '../../../providers/routine_provider.dart';
import '../../../data/models/pet.dart';
import '../../../data/models/routine.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  // We use this to track which pet is currently selected. 'All' means show everyone.
  String selectedPetId = 'All';

  @override
  Widget build(BuildContext context) {
    final pets = ref.watch(petProvider);

    // 1. Gather all routines (Applying the filter!)
    List<Map<String, dynamic>> todaysTasks = [];
    
    for (var pet in pets) {
      // If a specific pet is selected, skip the other pets
      if (selectedPetId != 'All' && pet.id != selectedPetId) {
        continue;
      }

      final routines = ref.watch(routineProvider(pet.id));
      for (var routine in routines) {
        todaysTasks.add({
          'pet': pet,
          'routine': routine,
        });
      }
    }

    // 2. Sort them chronologically (Morning to Night)
    todaysTasks.sort((a, b) {
      final t1 = a['routine'].time as DateTime;
      final t2 = b['routine'].time as DateTime;
      if (t1.hour != t2.hour) {
        return t1.hour.compareTo(t2.hour);
      }
      return t1.minute.compareTo(t2.minute);
    });

    final now = DateTime.now();
    final dateString = DateFormat('EEEE, MMMM d').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Welcome Header ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  dateString,
                  style: TextStyle(fontSize: 16, color: Colors.teal.shade100),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),

          // --- The New Pet Filter Bar ---
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ChoiceChip(
                  label: const Text('All Pets'),
                  selected: selectedPetId == 'All',
                  selectedColor: Colors.teal.shade100,
                  onSelected: (selected) {
                    setState(() => selectedPetId = 'All');
                  },
                ),
                const SizedBox(width: 8),
                // Generate a chip for every pet you own
                ...pets.map((pet) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(pet.name),
                        selected: selectedPetId == pet.id,
                        selectedColor: Colors.teal.shade100,
                        onSelected: (selected) {
                          setState(() => selectedPetId = pet.id);
                        },
                      ),
                    )),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // --- Task List ---
          Expanded(
            child: todaysTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text('All caught up!', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: todaysTasks.length,
                    itemBuilder: (context, index) {
                      final task = todaysTasks[index];
                      final Pet pet = task['pet'];
                      final Routine routine = task['routine'];

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade50,
                            child: Text(
                              pet.name[0].toUpperCase(), 
                              style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(routine.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          // We only show the pet name in the subtitle now to make it cleaner!
                          subtitle: Text('${routine.category} • ${pet.name}'),
                          trailing: Text(
                            DateFormat.jm().format(routine.time),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}