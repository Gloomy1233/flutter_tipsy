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
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),

                          const AnimatedGradientIcon(
                            icon: Icons.date_range_sharp,
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
                                viewModel.dateOfBirth = formattedDate;
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
                        AnimatedGradientIcon(
                          icon: sexIconMap[sex] ?? Icons.help_outline,
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
                    fontSize: 8.sp,
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
                        AnimatedGradientIcon(
                          icon: statusOptionsIconMap[status] ??
                              Icons.help_outline,
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
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w100,
                  ),
                  filled: true,
                  fillColor: primaryDarkLighter,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Bio TextField
            TextFormField(
              controller: bioController,
              decoration: const InputDecoration(
                labelText: "Bio",
              ),
              maxLines: 5,
              onChanged: (value) {
                viewModel.bio = value;
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ));
  }
}

class AnimatedGradientIcon extends StatefulWidget {
  final IconData icon;

  const AnimatedGradientIcon({
    super.key,
    required this.icon,
  });

  @override
  _AnimatedGradientIconState createState() => _AnimatedGradientIconState();
}

class _AnimatedGradientIconState extends State<AnimatedGradientIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = LinearGradient(
      colors: const [gradientOrange, primaryPink],
      begin: Alignment(_animation.value, -1.0),
      end: Alignment(-_animation.value, 1.0),
    );

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return gradient.createShader(bounds);
      },
      child: Icon(
        widget.icon,
        color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
