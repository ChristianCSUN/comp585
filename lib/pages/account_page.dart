import 'package:flutter/material.dart';
import 'package:stockappflutter/components/menu_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isDarkTheme = false; // State for theme switch
  bool notificationsEnabled = true; // State for notifications switch

  void _showThemeSnackBar(bool isDark) {
    final icon = isDark ? Icons.nightlight_round : Icons.wb_sunny;
    final text = isDark ? 'Dark Mode Enabled' : 'Light Mode Enabled';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16, // Larger font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 1), // Show for 1 second
        backgroundColor: isDark ? Colors.black87 : Colors.orangeAccent,
      ),
    );
  }

  void _showNotificationSnackBar(bool isEnabled) {
    final icon = isEnabled ? Icons.notifications : Icons.notifications_off;
    final text = isEnabled ? 'Notifications Enabled' : 'Notifications Disabled';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16, // Larger font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 1), // Show for 1 second
        backgroundColor: isEnabled ? Colors.green : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get the current user

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      endDrawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 75,
                backgroundImage: AssetImage(
                    'lib/assets/WWprofile.png'), // Replace with actual image
              ),
              const SizedBox(height: 25),
              Text(
                user?.email ??
                    'No email available', // Display dynamic email or fallback
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dark Theme',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: isDarkTheme,
                    onChanged: (bool value) {
                      setState(() {
                        isDarkTheme = value; // Toggle theme state
                      });
                      _showThemeSnackBar(value); // Show SnackBar
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: notificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        notificationsEnabled =
                            value; // Toggle notifications state
                      });
                      _showNotificationSnackBar(value); // Show SnackBar
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
