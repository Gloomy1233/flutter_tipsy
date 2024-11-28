import 'package:flutter/material.dart';

import '../screens/home_screens/user_screens/search_event_screen.dart';

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

var iconsMainScreenHost = <Widget>[
  const Icon(Icons.block, size: 30, color: Colors.white),
  const Icon(Icons.query_stats_sharp, size: 30, color: Colors.white),
  const Icon(Icons.event, size: 30, color: Colors.white),
  const Icon(Icons.book_rounded, size: 30, color: Colors.white),
  const Icon(Icons.swap_horiz_sharp, size: 30, color: Colors.white),
];

const screensMainScreenHost = [
  Center(child: Text("Blocked Users", style: TextStyle(fontSize: 24))),
  Center(child: Text("Statistics", style: TextStyle(fontSize: 24))),
  Center(child: Text("Create Event", style: TextStyle(fontSize: 24))),
  Center(child: Text("Organizer", style: TextStyle(fontSize: 24))),
  Center(child: Text("Swap User", style: TextStyle(fontSize: 24))),
];

// Initial Screens and Icons
List<Widget> screensMainScreenGuest = [
  const Center(child: Text("Interactions", style: TextStyle(fontSize: 24))),
  const Center(child: Text("Event History", style: TextStyle(fontSize: 24))),
  const SearchEventScreen(),
  const Center(child: Text("Follows", style: TextStyle(fontSize: 24))),
  const Center(child: Text("Swap User", style: TextStyle(fontSize: 24))),
];

var iconsMainScreenGuest = <Widget>[
  const Icon(Icons.people, size: 30, color: Colors.white),
  const Icon(Icons.history, size: 30, color: Colors.white),
  const Icon(Icons.search, size: 30, color: Colors.white),
  const Icon(Icons.accessibility_outlined, size: 30, color: Colors.white),
  const Icon(Icons.swap_horiz_sharp, size: 30, color: Colors.white),
];
