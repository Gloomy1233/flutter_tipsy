// widgets/background_shapes.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:sizer/sizer.dart';

class BackgroundShapes extends StatefulWidget {
  const BackgroundShapes({super.key});

  @override
  _BackgroundShapesState createState() => _BackgroundShapesState();
}

class _BackgroundShapesState extends State<BackgroundShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _rotationAnimation1;
  // Repeat for other shapes...

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _scaleAnimation1 = Tween(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    _rotationAnimation1 = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
    // Initialize other animations...
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // First Circle
        Positioned(
          top: -10.h,
          left: -10.w,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation1.value,
                child: Transform.rotate(
                  angle: _rotationAnimation1.value,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: primaryPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Add other circles similarly...
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
