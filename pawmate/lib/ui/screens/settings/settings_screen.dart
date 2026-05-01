import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // A visual mock-up for a Dark Mode toggle
          SwitchListTile(
            title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Switch to a dark theme'),
            value: false, // We'll wire this up to Riverpod later!
            onChanged: (bool value) {
              // TODO: Implement Dark Mode switch
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // TODO: Navigate to notification settings
            },
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