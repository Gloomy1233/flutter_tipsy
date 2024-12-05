import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  _DeleteConfirmationDialogState createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true); // Repeat the animation indefinitely

    // Define an alignment animation that goes from left to right
    _alignmentAnimation = AlignmentTween(
      begin: Alignment(-2.0, 0.0), // Start from left
      end: Alignment(2.0, 0.0), // Move to right
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.purpleAccent,
                        Colors.cyanAccent,
                        Colors.greenAccent,
                      ],
                      begin: _alignmentAnimation.value, // Animated begin point
                      end: Alignment(_alignmentAnimation.value.x * -1, 0.0), // Animated end point to reverse
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.content,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(
                    widget.cancelText,
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                TextButton(
                  onPressed: widget.onConfirm,
                  child: Text(
                    widget.confirmText,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
