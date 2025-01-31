import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/home_screens/host_screens/create_event_screens/create_event_screen.dart';

import '../screens/home_screens/host_screens/organizer_screens/organizer_screen.dart';
import '../screens/home_screens/user_screens/search_event_screen.dart';

// Colors
const Color primaryDark = Color(0xFF262838);
const Color primaryDarkLighter = Color(0xFF3A3C4E);
const Color primaryDarkEvenLighter = Color(0xC96F738B);

const Color primaryOrange = Color(0xFFE8827C);
const Color gradientOrange = Color(0xFFF5C8A3);

// Gradients

// Other colors used in background shapes
const Color primaryPink = Color(0xFFD7BBF5);
const Color shapeColor2 = Color(0xFFA3DFF5);
const Color shapeColor3 = Color(0xFFF5C8A3);

const Color primaryPinkLight = Color(0x90D7BBF5);
const Color shapeColor3Light = Color(0x90F5C8A3);

const LinearGradient gradient = LinearGradient(
  colors: [primaryPink, shapeColor3],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const LinearGradient gradientGreen = LinearGradient(
  colors: [Colors.greenAccent, Colors.purpleAccent],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
const LinearGradient gradientLight = LinearGradient(
  colors: [primaryPinkLight, shapeColor3Light],
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
  CreateEventScreen(),
  OrganizerScreen(),
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

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.0.2.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///  theme: AppTheme.light,
///  darkTheme: AppTheme.dark,
///  :
/// );
sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      // Custom colors
      primary: primaryDark,
      primaryContainer: shapeColor3,
      primaryLightRef: primaryPink,
      secondary: primaryOrange,
      secondaryContainer: gradientOrange,
      secondaryLightRef: FlexColor.purpleM3LightPrimary,
      tertiary: FlexColor.amberLightTertiary,
      tertiaryContainer: shapeColor3,
      tertiaryLightRef: FlexColor.bahamaBlueLightSecondaryVariant,
      appBarColor: Colors.cyan,
      error: FlexColor.redLightSecondaryVariant,
      errorContainer: Color(0xFFFFDAD6),
    ),
    swapColors: true,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      thinBorderWidth: 1.0,
      adaptiveSplash: FlexAdaptive.all(),
      splashType: FlexSplashType.inkSplash,
      adaptiveElevationShadowsBack: FlexAdaptive.all(),
      adaptiveRadius: FlexAdaptive.all(),
      defaultRadiusAdaptive: 7.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(
      useTertiary: true,
      useError: true,
      useExpressiveOnContainerColors: true,
    ),
    tones: FlexSchemeVariant.soft.tones(Brightness.light),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The inverted dark theme.
  static ThemeData dark = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      // Inverted or complementary custom colors
      primary: primaryDarkLighter, // Light theme's primaryLightRef
      primaryContainer: primaryDark, // Light theme's primary
      primaryLightRef: shapeColor3, // Light theme's primaryContainer
      secondary: gradientOrange, // Light theme's secondaryContainer
      secondaryContainer: primaryOrange, // Light theme's secondary
      secondaryLightRef:
          FlexColor.greenDarkPrimaryVariant, // Light theme's tertiaryLightRef
      tertiary: FlexColor.blueM3DarkPrimary, // Light theme's tertiaryContainer
      tertiaryContainer:
          primaryDarkLighter, // Slightly lighter shade of the dark theme primary
      tertiaryLightRef:
          FlexColor.purpleM3LightPrimary, // Light theme's secondaryLightRef
      appBarColor: Colors.black, // Dark app bar for contrast
      error: Color(0xFFFFB4AB), // Complementary error color
      errorContainer: Color(0xFF93000A), // Darker shade of error container
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      adaptiveSplash: FlexAdaptive.all(),
      splashType: FlexSplashType.inkSplash,
      adaptiveRadius: FlexAdaptive.all(),
      defaultRadiusAdaptive: 7.0,
      thinBorderWidth: 1.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(
      useTertiary: true,
      useError: true,
    ),
    tones: FlexSchemeVariant.soft.tones(Brightness.dark),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
