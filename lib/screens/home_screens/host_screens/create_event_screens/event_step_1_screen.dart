import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/app_theme_text_form_field.dart';

class EventStep1Screen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController paragraphController = TextEditingController();
  final TextEditingController maxGuestsController = TextEditingController();

  EventStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              "Some important info for your party",
              style: TextStyle(
                color: primaryDark,
                fontSize: 18.sp,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: 4.h),

            // Title Field
            AppThemeTextFormField(
              controller: titleController,
              labelText: "Title",
              hintText: "My Party",
              onChanged: (value) {
                // Handle title input change
              },
            ),
            SizedBox(height: 4.h),

            // Paragraph Field
            AppThemeTextFormField(
              controller: paragraphController,
              labelText: "Paragraph",
              hintText: "Write something interesting about your event here...",
              maxLines: 5,
              onChanged: (value) {
                // Handle paragraph input change
              },
            ),
            SizedBox(height: 4.h),

            // Open Party and Maximum Guests
            Row(
              children: [
                // Open Party Toggle
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Open Party",
                        style: TextStyle(
                          color: primaryDark,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Switch(
                            value: true, // Replace with actual state
                            onChanged: (value) {
                              // Handle switch toggle
                            },
                            activeColor: primaryOrange,
                          ),
                          Icon(
                            Icons.help_outline,
                            color: primaryPink,
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),

                // Maximum Guests
                Expanded(
                  flex: 3,
                  child: AppThemeTextFormField(
                    controller: maxGuestsController,
                    labelText: "Maximum Guests",
                    hintText: "150",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // Handle max guests input change
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // Features Section
            Text(
              "Features",
              style: TextStyle(
                color: primaryDark,
                fontSize: 16.sp,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: 2.h),

            // Features Tags
            Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: primaryDarkLighter,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search for parties...",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.5.h, // Adjust height
                          horizontal: 12.0, // Adjust left and right padding
                        ),
                      ),
                      style: TextStyle(fontSize: 12.sp), // Smaller font size
                    ),
                    SizedBox(height: 2.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: [
                        _buildFeatureChip(
                            "Strobe Lights/Laser Lights", Icons.light),
                        _buildFeatureChip("Hot Tub", Icons.hot_tub),
                        _buildFeatureChip("Large Place", Icons.house),
                        _buildFeatureChip("Woofer-SubWoofer", Icons.speaker),
                        _buildFeatureChip(
                            "Edm-Rave-Drum n’Bass", Icons.music_note),
                        _buildFeatureChip(
                            "Bring your own booze", Icons.local_drink),
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 4.h),

            // Navigation Buttons
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryOrange, size: 12.sp),
          SizedBox(width: 1.w),
          Text(
            label,
            style: TextStyle(
              color: primaryDark,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
    );
  }
}
