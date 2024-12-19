import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/app_theme_text_form_field.dart';
import '../../widgets_home/search_widget.dart';

class EventStep1Screen extends StatefulWidget {
  EventStep1Screen({super.key});

  @override
  State<EventStep1Screen> createState() => _EventStep1ScreenState();
}

class _EventStep1ScreenState extends State<EventStep1Screen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController paragraphController = TextEditingController();
  final TextEditingController maxGuestsController = TextEditingController();
  final TextEditingController dateOfBirthController =
      TextEditingController(text: "adsads");

  bool isAddressVisible = false;

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
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Want address to be visible",
                        style: TextStyle(
                          color: primaryDark,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.help_outline, color: primaryPink, size: 14.sp),
                      Spacer(),
                      Switch(
                        value: isAddressVisible,
                        onChanged: (value) {
                          setState(() {
                            isAddressVisible = value;
                          });
                        },
                        activeColor: primaryOrange,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 10),
                          blurRadius: 6,
                        ),
                      ],
                      border: Border.all(color: primaryDark, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  "Date",
                                  style: TextStyle(
                                    color: primaryDark,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.date_range_sharp,
                                color: primaryDark,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 7.w),
                            child: TextFormField(
                              controller: dateOfBirthController,
                              readOnly: true,
                              textAlign: TextAlign.left,
                              onTap: () async {
                                // Show date picker (your existing code)
                              },
                              style: TextStyle(
                                color: primaryDark,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: primaryDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Removed the Expanded widget below
            /*
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 7.w),
                child: TextFormField(
                  controller: dateOfBirthController,
                  readOnly: true,
                  textAlign: TextAlign.left,
                  onTap: () async {
                    // Show date picker (your existing code)
                  },
                  style: TextStyle(
                    color: primaryDark,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: primaryDark,
            ),
            */

            // Features Section
            Text(
              "Party Theme",
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
                  SearchWidget(),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Navigation Buttons
            // Add your navigation buttons here
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
