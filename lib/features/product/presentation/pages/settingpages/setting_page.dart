import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_dashboard/core/theme/theme.cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String language = 'English';
  String currency = 'USD';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            'Settings',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your application',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

  
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: ListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Change theme'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),
          ),
          const SizedBox(height: 16),


          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: ListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Get updates and alerts'),
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (val) {
                  setState(() => notificationsEnabled = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

     
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: ListTile(
              title: const Text('Language'),
              subtitle: Text(language),
              trailing: DropdownButton<String>(
                value: language,
                onChanged: (value) {
                  setState(() => language = value!);
                },
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Urdu', child: Text('Urdu')),
                  DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: ListTile(
              title: const Text('Currency'),
              subtitle: Text(currency),
              trailing: DropdownButton<String>(
                value: currency,
                onChanged: (value) {
                  setState(() => currency = value!);
                },
                items: const [
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                  DropdownMenuItem(value: 'PKR', child: Text('PKR')),
                  DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),


          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved successfully!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
