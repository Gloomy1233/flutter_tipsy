import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:sizer/sizer.dart';

import '../../viewmodels/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserDataModel userData;
  const ProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int userAge = _calculateAge(userData.dateOfBirth);
    final String userSex = _mapSexToString(userData.sex);
    final String relationship =
        _mapRelationshipStatus(userData.relationshipStatus);

    return DefaultTabController(
      length: 3, // We have 3 tabs (About, Rating, Photos)
      child: Scaffold(
        body: Stack(
          children: [
            // -- Background Gradient --
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFDEFEF), // Light pink
                    Color(0xFFDFFFFD), // Light green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // -- Main Content --
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 48.0, // Space for status bar
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- Profile Card --
                    _buildProfileCard(context, userAge, userSex, relationship),
                    const SizedBox(height: 24),

                    // -- TabBar Row --
                    Container(
                      decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.white,
                        tabs: const [
                          Tab(text: 'About'),
                          Tab(text: 'Rating'),
                          Tab(text: 'Photos'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // -- TabBarView for displaying content dynamically --
                    SizedBox(
                      height: 400, // Adjust height as needed
                      child: TabBarView(
                        children: [
                          _buildBioSection(context), // About tab content
                          _buildRatingSection(context), // Rating tab content
                          _buildPhotosSection(context), // Photos tab content
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the user profile card at the top of the screen.
  Widget _buildProfileCard(
      BuildContext context, int userAge, String userSex, String relationship) {
    return Card(
      color: const Color(0xFFFFF4F5),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelValueRow(context,
                      label: "Name", value: userData.fullName),
                  _labelValueRow(context,
                      label: "Age", value: userAge.toString()),
                  _labelValueRow(context, label: "Gender", value: userSex),
                  _labelValueRow(context,
                      label: "Relationship Status", value: relationship),
                ],
              ),
            ),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    userData.profilePictureUrl ??
                        'https://via.placeholder.com/80',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.group_add, size: 16),
                    SizedBox(width: 4),
                    Text('Follow'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Label + Value Row for profile card
  Widget _labelValueRow(BuildContext context,
      {required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[700])),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black87)),
        const SizedBox(height: 8),
      ],
    );
  }

  /// About Tab Content - BIO Section
  Widget _buildBioSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 2,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 100.w,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BIO',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text(userData.bio,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[800], height: 1.4)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Communication',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          color: const Color(0xFFFFF4F5), // Light pastel card color
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.email),
                Icon(Icons.facebook),
                Icon(Icons.camera_alt),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Rating Tab Content
  Widget _buildRatingSection(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text('Insert Pie Charts / Stats here')),
      ),
    );
  }

  /// Photos Tab Content
  Widget _buildPhotosSection(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text('Insert User Photos here')),
      ),
    );
  }
}

// ---------------------------------------------------------------------
//  HELPER METHODS
// ---------------------------------------------------------------------

/// Converts a date string ("YYYY-MM-DD") to age.
int _calculateAge(String dateOfBirth) {
  try {
    final parts = dateOfBirth.split('-');
    if (parts.length == 3) {
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      final dob = DateTime(year, month, day);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    }
    return 0;
  } catch (_) {
    return 0;
  }
}

/// Maps gender integer to a string.
String _mapSexToString(int sex) {
  switch (sex) {
    case 1:
      return 'Male';
    case 2:
      return 'Female';
    default:
      return 'Other';
  }
}

/// Maps relationship status integer to a string.
String _mapRelationshipStatus(int status) {
  switch (status) {
    case 1:
      return 'Single';
    case 2:
      return 'Married';
    case 3:
      return 'Complicated';
    default:
      return 'Unknown';
  }
}
