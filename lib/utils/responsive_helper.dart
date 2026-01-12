import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return screenWidth(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return screenWidth(context) >= 600 && screenWidth(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= 1200;
  }

  // Responsive font sizes
  static double getFontSize(BuildContext context, {double baseSize = 14}) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * 1.2;
    return baseSize * 1.4;
  }

  // Responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  // Responsive margins
  static EdgeInsets getMargin(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(8);
    if (isTablet(context)) return const EdgeInsets.all(12);
    return const EdgeInsets.all(16);
  }

  // Responsive icon sizes
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * 1.3;
    return baseSize * 1.6;
  }

  // Responsive container heights
  static double getContainerHeight(BuildContext context, {double baseHeight = 100}) {
    if (isMobile(context)) return baseHeight;
    if (isTablet(context)) return baseHeight * 1.2;
    return baseHeight * 1.4;
  }

  // Responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  // Responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    if (isMobile(context)) return 60;
    if (isTablet(context)) return 70;
    return 80;
  }

  // Responsive spacing
  static double getSpacing(BuildContext context, {double baseSpacing = 8}) {
    if (isMobile(context)) return baseSpacing;
    if (isTablet(context)) return baseSpacing * 1.5;
    return baseSpacing * 2;
  }
}

