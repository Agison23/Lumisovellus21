import 'package:flutter/material.dart';

/// Responsive layout helper widget that provides breakpoints and utilities
/// for creating responsive designs across different screen sizes.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final BuildContext context;

  const ResponsiveLayout({
    super.key,
    required this.context,
    required this.child,
  });

  /// Get screen width
  double get width => MediaQuery.of(context).size.width;

  /// Get screen height
  double get height => MediaQuery.of(context).size.height;

  /// Get the smaller dimension
  double get minDimension => width < height ? width : height;

  /// Get the larger dimension
  double get maxDimension => width > height ? width : height;

  /// Check if screen is small (width < 600)
  bool get isSmallScreen => width < 600;

  /// Check if screen is medium (600 <= width < 900)
  bool get isMediumScreen => width >= 600 && width < 900;

  /// Check if screen is large (width >= 900)
  bool get isLargeScreen => width >= 900;

  /// Get responsive padding based on screen size
  EdgeInsets get responsivePadding => EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.02,
      );

  /// Get responsive spacing based on screen size
  double get responsiveSpacing => height * 0.02;

  /// Get responsive font scale factor (based on 1080px reference width)
  double get fontScaleFactor => width / 1080.0;

  /// Scale a value proportionally based on screen width
  double scaleWidth(double value) => value * (width / 1080.0);

  /// Scale a value proportionally based on screen height
  double scaleHeight(double value) => value * (height / 2400.0);

  /// Scale a value proportionally based on the smaller dimension
  double scaleMin(double value) => value * (minDimension / 720.0);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Extension to easily access ResponsiveLayout from BuildContext
extension ResponsiveLayoutExtension on BuildContext {
  ResponsiveLayout get responsive => ResponsiveLayout(
        context: this,
        child: const SizedBox.shrink(),
      );
}

