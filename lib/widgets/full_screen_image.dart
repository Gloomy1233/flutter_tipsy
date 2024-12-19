
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;

  const FullScreenImage({super.key, required this.imageUrl, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
      body: Center(
        child: Image.network(imageUrl, fit: BoxFit.contain)
      ),
    );
  }
}
