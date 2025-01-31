import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5, // Half the screen
      decoration: BoxDecoration(
        color: const Color(0xFF2E2B3F), // Dark background
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Profile Settings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade100, // Light pink color
              ),
            ),
          ),
          const Divider(color: Colors.white30),

          // Settings Options
          _buildSettingsItem("Profile Options"),
          _buildSettingsItem("Payment Options"),
          _buildSettingsItem("Language Settings"),
          _buildSettingsItem("Notification Settings"),

          // Support Section
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "Support",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade200, // Soft orange color
              ),
            ),
          ),
          const Divider(color: Colors.white30),
          _buildSettingsItem("How it works"),
          _buildSettingsItem("Support Center"),
          _buildSettingsItem("Feedback"),
          _buildSettingsItem("Privacy Policy"),

          // Logout Button
          const Spacer(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  /// Reusable settings option row
  Widget _buildSettingsItem(String title) {
    return InkWell(
      onTap: () {}, // Add navigation logic here
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.orange.shade100,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.orange.shade100),
          ],
        ),
      ),
    );
  }

  /// Logout button
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextButton.icon(
        onPressed: () {}, // Add logout logic
        icon: const Icon(Icons.logout, color: Colors.pinkAccent),
        label: Text(
          "Signout",
          style: TextStyle(fontSize: 16, color: Colors.orange.shade200),
        ),
      ),
    );
  }
}

/// Function to Show the Bottom Drawer
void showSettingsDrawer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const SettingsDrawer(),
  );
}
