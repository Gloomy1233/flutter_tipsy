import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../viewmodels/registration_viewmodel.dart';

class Step3Screen extends StatefulWidget {
  const Step3Screen({super.key});

  @override
  _Step3ScreenState createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  // State variables
  late int selectedSex;
  late int selectedStatus;

  final List<String> sexOptions = ["Male", "Female", "Other"];

  final List<String> statusOptions = [
    "Single",
    "In a relationship",
    "Married",
    "It's complicated"
  ];

  // Controllers
  late TextEditingController dateOfBirthController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<RegistrationViewModel>(context, listen: false);

    selectedSex = viewModel.sex; // Initialize selectedSex
    selectedStatus = viewModel.relationshipStatus; // Initialize selectedStatus

    dateOfBirthController = TextEditingController(text: "2000-01-21");
    bioController = TextEditingController(text: viewModel.bio);
  }

  @override
  void dispose() {
    dateOfBirthController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final viewModel = Provider.of<RegistrationViewModel>(context);

    return SizedBox.expand(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "You can leave this blank and edit it later",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Date of Birth TextField
// Date of Birth TextField
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                color: primaryDarkLighter,
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
                                color: primaryOrange,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.date_range_sharp,
                            color: primaryPink,
                          ),

                          // Spacing between icon and label
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 7.w),
                        child: TextFormField(
                          controller: dateOfBirthController,
                          readOnly: true,
                          textAlign:
                              TextAlign.left, // Align the text to the right
                          onTap: () async {
                            // Show date picker
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                String formattedDate =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                dateOfBirthController.text = formattedDate;
                                //viewModel.dateOfBirth = formattedDate;
                                viewModel.setDate(
                                    DateTime.parse(formattedDate)
                                        .microsecondsSinceEpoch,
                                    formattedDate);
                                print(
                                    "afaffsfa${viewModel.dateOfBirth}${viewModel.timestampOfBirth}");
                              });
                            }
                          },
                          style: TextStyle(
                            foreground: Paint()
                              ..shader = gradient.createShader(
                                Rect.fromLTWH(
                                  0.0,
                                  0.0,
                                  MediaQuery.of(context).size.width / 10,
                                  MediaQuery.of(context).size.height,
                                ),
                              ),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // Remove underline
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Sex Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: DropdownButtonFormField<String>(
                dropdownColor: primaryDarkLighter,
                value: sexOptions[selectedSex],
                items: sexOptions.map((sex) {
                  return DropdownMenuItem<String>(
                    value: sex,
                    child: Row(
                      children: [
                        Icon(
                          sexIconMap[sex] ?? Icons.help_outline,
                          color: primaryPink, // Use a static color or gradient
                        ),
                        SizedBox(width: 10.w),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return gradient.createShader(
                              Rect.fromLTRB(0, 0, bounds.width, bounds.height),
                            );
                          },
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            sex,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              color: Colors.white, // Fallback color
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    for (var i = 0; i < sexOptions.length; i++) {
                      if (sexOptions[i] == newValue) {
                        selectedSex = i; // Corrected assignment
                        viewModel.setSex(i);
                        break;
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: "Sex",
                  labelStyle: TextStyle(
                    color: primaryOrange,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w100,
                  ),
                  filled: true,
                  fillColor: primaryDarkLighter,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Relationship Status Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: DropdownButtonFormField<String>(
                dropdownColor: primaryDarkLighter,
                value: statusOptions[selectedStatus],
                items: statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Row(
                      children: [
                        Icon(
                          statusOptionsIconMap[status] ?? Icons.help_outline,
                          color: primaryPink,
                        ),
                        SizedBox(width: 10.w),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return gradient.createShader(
                              Rect.fromLTRB(0, 0, bounds.width, bounds.height),
                            );
                          },
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              color: Colors.white, // Fallback color
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    for (var i = 0; i < 4; i++) {
                      if (statusOptions[i] == newValue) {
                        selectedStatus = i;
                        viewModel.setRelationshipStatus(i);
                        break;
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                  // icon: Icon(
                  //   statusOptionsIconMap[statusOptions[selectedStatus]] ??
                  //       Icons.help_outline,
                  // ),
                  labelText: "Relationship Status",
                  labelStyle: TextStyle(
                    color: primaryOrange,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w100,
                  ),
                  filled: true,
                  fillColor: primaryDarkLighter,
                ),
              ),
            ),
            // const SizedBox(height: 16),
            // // Bio TextField
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 4.w),
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 4.w),
            //     decoration: BoxDecoration(
            //       color: primaryDarkLighter,
            //       borderRadius: BorderRadius.circular(
            //           4.0), // Optional: for rounded corners
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(
            //             "Bio",
            //             style: TextStyle(
            //               color: primaryOrange,
            //               fontSize: 14.sp,
            //               fontWeight: FontWeight.w100,
            //             ),
            //           ),
            //         ),
            //         TextFormField(
            //           controller: bioController,
            //           maxLines: 5,
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             foreground: Paint()
            //               ..shader = gradient.createShader(
            //                 const Rect.fromLTRB(0, 0, 200.0,
            //                     70.0), // Adjust dimensions as needed
            //               ),
            //           ),
            //           onChanged: (value) {
            //             viewModel.bio = value; // Update the ViewModel or state
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            const SizedBox(height: 16),
            DynamicBioField(
              controller: bioController,
              maxCharacters: 200, // Set maximum characters
            )
          ],
        ),
      ),
    ));
  }
}

class DynamicBioField extends StatefulWidget {
  final TextEditingController controller;
  final int maxCharacters;

  const DynamicBioField({
    Key? key,
    required this.controller,
    this.maxCharacters = 200,
  }) : super(key: key);

  @override
  _DynamicBioFieldState createState() => _DynamicBioFieldState();
}

class _DynamicBioFieldState extends State<DynamicBioField> {
  int characterCount = 0;

  void _updateCharacterCount(String value) {
    setState(() {
      characterCount = value.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: primaryDarkLighter,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Bio",
                style: TextStyle(
                  color: primaryOrange,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            // Bio Input Field
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 5.h, // Minimum height of the field
                maxHeight: 50.h, // Maximum height allowed
              ),
              child: TextFormField(
                controller: widget.controller,
                maxLines: null, // Allow dynamic expansion
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = gradient.createShader(
                      const Rect.fromLTRB(0, 0, 200.0, 70.0),
                    ),
                ),
                onChanged: (value) {
                  // Prevent exceeding the max character limit
                  if (value.length > widget.maxCharacters) {
                    widget.controller.text =
                        value.substring(0, widget.maxCharacters);
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: widget.maxCharacters),
                    );
                  }
                  _updateCharacterCount(widget
                      .controller.text); // Update character count dynamically
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Character Counter
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '$characterCount/${widget.maxCharacters} characters',
                style: TextStyle(
                  color: Colors.white, // Highlight when exceeding the limit
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedGradientIcon extends StatelessWidget {
  final IconData icon;

  const AnimatedGradientIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: -2.0, end: 2.0),
      duration: const Duration(seconds: 3),
      builder: (context, double value, child) {
        final Gradient gradient = LinearGradient(
          colors: const [gradientOrange, primaryPink],
          begin: Alignment(value, -1.0),
          end: Alignment(-value, 1.0),
        );

        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return gradient.createShader(bounds);
          },
          child: Icon(
            icon,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
