import 'package:flutter/material.dart';
import 'package:flutter_tipsy/viewmodels/create_event_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/constants.dart';
import '../../../../viewmodels/current_user.dart';
import '../../../../widgets/app_theme_text_form_field.dart';

class EventStep1Screen extends StatefulWidget {
  EventStep1Screen({super.key});

  @override
  State<EventStep1Screen> createState() => _EventStep1ScreenState();
}

class _EventStep1ScreenState extends State<EventStep1Screen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController paragraphController = TextEditingController();
  final TextEditingController maxGuestsController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode paragraphFocusNode = FocusNode();

  String? titleError;
  String? paragraphError;

  bool isOpenParty = false;
  final _formKey = GlobalKey<FormState>();
  bool isBubbleVisible = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleBubble() {
    if (isBubbleVisible) {
      _removeBubble();
    } else {
      _showBubble();
    }
  }

  void _showBubble() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isBubbleVisible = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap outside to close
          GestureDetector(
            onTap: _removeBubble,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Speech Bubble Positioned
          Positioned(
            width: 220,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(-20.w, -10.h), // Adjusts position above the widget
              child: const SpeechBubble(
                message:
                    "If you have this on, there will be no limit of people who can request to join.",
                textColor: Colors.orangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = CurrentUser().user;
      if (currentUser == null) {
        Navigator.pushNamed(context, '/login');
      } else {
        Provider.of<CreateEventViewModel>(context, listen: false).uid =
            currentUser.uid;
      }
    });

    // Add listeners to the focus nodes
    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus) {
        if (titleController.text.length < 5) {
          setState(() {
            titleError = "Title must be at least 5 characters long.";
          });
        } else {
          setState(() {
            titleError = null;
          });
        }
      }
    });

    paragraphFocusNode.addListener(() {
      if (!paragraphFocusNode.hasFocus) {
        if (paragraphController.text.length < 100) {
          setState(() {
            paragraphError = "Paragraph must be at least 100 characters long.";
          });
        } else {
          setState(() {
            paragraphError = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    paragraphController.dispose();
    titleFocusNode.dispose();
    paragraphFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partyProvider =
        Provider.of<CreateEventViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 8.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              "Some important info for your party",
              style: TextStyle(
                color: primaryDark,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),

            AppThemeTextFormField(
              labelText: "Title",
              hintText: "Enter a short title",
              controller: titleController,

              maxLength: 20,
              errorText: titleError, // Pass dynamically set error
              onChanged: (value) {
                partyProvider.title = value;

                if (value.length >= 5) {
                  setState(() {
                    titleError = null; // Clear error
                  });
                } else {
                  setState(() {
                    titleError = "Title must be at least 5 characters long.";
                  });
                }
              },
            ),

            SizedBox(height: 4.h),

            // Paragraph Field
            AppThemeTextFormField(
              labelText: "Description",
              hintText: "Write something interesting about your event...",
              controller: paragraphController,
              maxLength: 200,
              errorText: paragraphError, // Pass dynamically set error
              onChanged: (value) {
                partyProvider.description = value;
                if (value.length >= 100) {
                  setState(() {
                    paragraphError = null; // Clear error
                  });
                } else {
                  setState(() {
                    paragraphError =
                        "Description must be at least 100 characters long.";
                  });
                }
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
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Switch(
                            onChanged: (value) {
                              setState(() {
                                isOpenParty = value;
                                partyProvider.isOpenParty = value;
                              });
                            },
                            activeColor: primaryOrange,
                            value: isOpenParty,
                          ),
                          CompositedTransformTarget(
                            link: _layerLink,
                            child: IconButton(
                              icon: Icon(Icons.help_outline, size: 16.sp),
                              color: primaryPink,
                              onPressed: () {
                                _toggleBubble();
                              },
                            ),
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
                    isDisabled: partyProvider.isOpenParty,
                    onChanged: (value) {
                      partyProvider.maxGuests = int.parse(value);
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
                                    fontWeight: FontWeight.w500,
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
                                // 1) Show Date Picker
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate == null) return;

                                // 2) Show Time Picker
                                final TimeOfDay? pickedTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 12, minute: 0),
                                );
                                if (pickedTime == null) return;

                                // 3) Combine date + time into a single DateTime
                                final combinedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );

                                // 4) Convert DateTime to a Firestore Timestamp

                                // 5) Format the DateTime as a string for display (YYYY-MM-DD HH:mm)
                                final formattedDateTime =
                                    "${combinedDateTime.year}"
                                    "-${combinedDateTime.month.toString().padLeft(2, '0')}"
                                    "-${combinedDateTime.day.toString().padLeft(2, '0')} "
                                    "${pickedTime.hour.toString().padLeft(2, '0')}:"
                                    "${pickedTime.minute.toString().padLeft(2, '0')}";

                                setState(() {
                                  dateOfBirthController.text =
                                      formattedDateTime;
                                  // Example: store DateTime in your provider
                                  partyProvider.date = combinedDateTime;
                                  // Example: store Timestamp if you need it for Firestore
                                  // partyProvider.timestamp = timestamp;  // (If you have a setter for that)
                                });
                              },
                              style: TextStyle(color: primaryDark),
                              decoration: const InputDecoration(
                                filled: false,
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

              // Navigation Buttons
            )
          ],
        ),
        // Speech Bubble (visible when isBubbleVisible is true)
      ),
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;

  const SpeechBubble({
    Key? key,
    required this.message,
    this.backgroundColor = const Color(0xFF46495B),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.all(12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CustomPaint(
        painter: SpeechBubblePainter(backgroundColor),
        child: Container(
          padding: padding,
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final Color color;

  SpeechBubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(20, 0)
      ..lineTo(size.width - 20, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 20)
      ..lineTo(size.width, size.height - 20)
      ..quadraticBezierTo(size.width, size.height, size.width - 20, size.height)
      ..lineTo(size.width * 0.5 + 10, size.height)
      ..lineTo(size.width * 0.5, size.height + 10) // Speech tail
      ..lineTo(size.width * 0.5 - 10, size.height)
      ..lineTo(20, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 20)
      ..lineTo(0, 20)
      ..quadraticBezierTo(0, 0, 20, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
