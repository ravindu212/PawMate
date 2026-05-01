import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- 1. Import Riverpod
import '../../../providers/theme_provider.dart'; // <-- 2. Import our new provider

// 3. Change StatelessWidget to ConsumerWidget
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. Ask the waiter for the current theme state
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Switch to a dark theme'),
            value: isDarkMode, // <-- 5. The switch turns on if this is true
            onChanged: (bool value) {
              // 6. Tell the waiter to flip the switch!
              ref.read(themeProvider.notifier).toggleTheme();
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {},
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About PawMate', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}