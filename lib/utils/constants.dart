import 'package:flutter/material.dart';

// Colors
const Color primaryDark = Color(0xFF262838);
const Color primaryDarkLighter = Color(0xFF3A3C4E);
const Color primaryDarkEvenLighter = Color(0xffffffff);

const Color primaryOrange = Color(0xFFE8827C);
const Color gradientOrange = Color(0xFFF5C8A3);

// Gradients

// Other colors used in background shapes
const Color primaryPink = Color(0xFFD7BBF5);
const Color shapeColor2 = Color(0xFFA3DFF5);
const Color shapeColor3 = Color(0xFFF5C8A3);
const LinearGradient gradient = LinearGradient(
  colors: [primaryPink, shapeColor3],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const LinearGradient gradient1 = LinearGradient(
  colors: [primaryDark, primaryDark],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
const Map<String, IconData> statusOptionsIconMap = {
  "Single": Icons.single_bed_sharp,
  "In a relationship": Icons.bed_sharp,
  "Married": Icons.church_sharp,
  "It's complicated": Icons.account_tree_outlined
};
final Map<String, IconData> sexIconMap = {
  "Male": Icons.male_sharp,
  "Female": Icons.female_sharp,
  "Other": Icons.transgender_sharp,
};
