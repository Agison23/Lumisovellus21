import 'package:flutter/material.dart';

/// Theme extension for Rescue Page specific colors and text styles.
///
/// This extension provides centralized color and text style management for
/// the rescue page, following Flutter best practices for theme customization.
class RescueTheme extends ThemeExtension<RescueTheme> {
  /// Background color for the rescue page
  final Color pageBackground;

  /// Color for coordinate display cells
  final Color coordinateCell;

  /// Place icon color
  final Color placeIconColor;

  /// Request help button color
  final Color requestHelpButton;

  /// Request help button color
  final Color requestHelpButtonText;

  /// Shadow color for request help button
  final Color requestHelpButtonShadow;

  /// Background color for secondary buttons (e.g., "Show on Map")
  final Color secondaryButtonBackground;

  /// Border color for emergency call button
  final Color emergencyCallBorder;

  /// Background color for emergency call button
  final Color emergencyCallBackground;

  /// Text color for emergency call button
  final Color emergencyCallForeground;

  /// Background color for card containers
  final Color cardBackground;

  /// Shadow color for cards
  final Color cardShadow;

  /// Text style for coordinate cell values
  final TextStyle coordinateCellStyle;

  /// Text style for coordinate direction labels
  final TextStyle coordinateDirectionStyle;

  /// Text style for description text (help request, emergency call)
  final TextStyle descriptionStyle;

  /// Text style for request help button
  final TextStyle requestHelpButtonStyle;

  /// Text style for emergency call button text
  final TextStyle emergencyCallButtonStyle;

  /// Text style for secondary button labels
  final TextStyle secondaryButtonStyle;

  /// Text style for dialog title
  final TextStyle dialogTitleStyle;

  /// Text style for dialog radio option text
  final TextStyle dialogRadioStyle;

  const RescueTheme({
    required this.pageBackground,
    required this.coordinateCell,
    required this.placeIconColor,
    required this.requestHelpButton,
    required this.requestHelpButtonText,
    required this.requestHelpButtonShadow,
    required this.secondaryButtonBackground,
    required this.emergencyCallBorder,
    required this.emergencyCallBackground,
    required this.emergencyCallForeground,
    required this.cardBackground,
    required this.cardShadow,
    required this.coordinateCellStyle,
    required this.coordinateDirectionStyle,
    required this.descriptionStyle,
    required this.requestHelpButtonStyle,
    required this.emergencyCallButtonStyle,
    required this.secondaryButtonStyle,
    required this.dialogTitleStyle,
    required this.dialogRadioStyle,
  });

  // Shared text style definitions - these are the same across all themes
  static const TextStyle _coordinateCellStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle _coordinateDirectionStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _descriptionStyle = TextStyle(
    fontSize: 18,
  );

  static const TextStyle _requestHelpButtonStyle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _emergencyCallButtonStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _secondaryButtonStyle = TextStyle(
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
  );

  static const TextStyle _dialogTitleStyle = TextStyle(
    fontSize: 20,
  );

  static const TextStyle _dialogRadioStyle = TextStyle(
    fontSize: 16,
  );

  /// Default light theme colors and text styles
  factory RescueTheme.light() {
    return const RescueTheme(
      pageBackground: Color(0xFAFAFAFA),
      coordinateCell: Color.fromARGB(217, 111, 114, 117),
      placeIconColor: Color(0xFF415A77),
      requestHelpButton: Color.fromARGB(255, 175, 5, 5),
      requestHelpButtonText: Color.fromARGB(255, 242, 240, 240),
      requestHelpButtonShadow: Color.fromARGB(116, 186, 186, 188),
      secondaryButtonBackground: Color(0xfffafafa),
      emergencyCallBorder: Color(0xFF415A77),
      emergencyCallBackground: Color.fromARGB(255, 234, 233, 233),
      emergencyCallForeground: Color(0xFF415A77),
      cardBackground: Colors.white,
      cardShadow: Color(0xFFBDBDBD),
      coordinateCellStyle: _coordinateCellStyle,
      coordinateDirectionStyle: _coordinateDirectionStyle,
      descriptionStyle: _descriptionStyle,
      requestHelpButtonStyle: _requestHelpButtonStyle,
      emergencyCallButtonStyle: _emergencyCallButtonStyle,
      secondaryButtonStyle: _secondaryButtonStyle,
      dialogTitleStyle: _dialogTitleStyle,
      dialogRadioStyle: _dialogRadioStyle,
    );
  }

  /// Default dark theme colors and text styles
  factory RescueTheme.dark() {
    return const RescueTheme(
      pageBackground: Color(0xFF121212),
      coordinateCell: Color.fromARGB(255, 90, 130, 170),
      placeIconColor: Color.fromARGB(217, 111, 114, 117),
      requestHelpButton: Color(0xFFD32F2F),
      requestHelpButtonText: Color(0xFFFAFAFA),
      requestHelpButtonShadow: Color(0xFF000000),
      secondaryButtonBackground: Color(0xFF2C2C2C),
      emergencyCallBorder: Color(0xFFB0BEC5),
      emergencyCallBackground: Color(0xFF424242),
      emergencyCallForeground: Color(0xFFE0E0E0),
      cardBackground: Color(0xFF1E1E1E),
      cardShadow: Color(0xFF000000),
      coordinateCellStyle: _coordinateCellStyle,
      coordinateDirectionStyle: _coordinateDirectionStyle,
      descriptionStyle: _descriptionStyle,
      requestHelpButtonStyle: _requestHelpButtonStyle,
      emergencyCallButtonStyle: _emergencyCallButtonStyle,
      secondaryButtonStyle: _secondaryButtonStyle,
      dialogTitleStyle: _dialogTitleStyle,
      dialogRadioStyle: _dialogRadioStyle,
    );
  }

  @override
  ThemeExtension<RescueTheme> copyWith({
    Color? pageBackground,
    Color? coordinateCell,
    Color? placeIconColor,
    Color? requestHelpButton,
    Color? requestHelpButtonText,
    Color? requestHelpButtonShadow,
    Color? secondaryButtonBackground,
    Color? emergencyCallBorder,
    Color? emergencyCallBackground,
    Color? emergencyCallForeground,
    Color? cardBackground,
    Color? cardShadow,
    TextStyle? coordinateCellStyle,
    TextStyle? coordinateDirectionStyle,
    TextStyle? descriptionStyle,
    TextStyle? requestHelpButtonStyle,
    TextStyle? emergencyCallButtonStyle,
    TextStyle? secondaryButtonStyle,
    TextStyle? dialogTitleStyle,
    TextStyle? dialogRadioStyle,
  }) {
    return RescueTheme(
      pageBackground: pageBackground ?? this.pageBackground,
      coordinateCell: coordinateCell ?? this.coordinateCell,
      placeIconColor: placeIconColor ?? this.placeIconColor,
      requestHelpButton: requestHelpButton ?? this.requestHelpButton,
      requestHelpButtonText:
          requestHelpButtonText ?? this.requestHelpButtonText,
      requestHelpButtonShadow:
          requestHelpButtonShadow ?? this.requestHelpButtonShadow,
      secondaryButtonBackground:
          secondaryButtonBackground ?? this.secondaryButtonBackground,
      emergencyCallBorder: emergencyCallBorder ?? this.emergencyCallBorder,
      emergencyCallBackground:
          emergencyCallBackground ?? this.emergencyCallBackground,
      emergencyCallForeground:
          emergencyCallForeground ?? this.emergencyCallForeground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardShadow: cardShadow ?? this.cardShadow,
      coordinateCellStyle: coordinateCellStyle ?? this.coordinateCellStyle,
      coordinateDirectionStyle:
          coordinateDirectionStyle ?? this.coordinateDirectionStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      requestHelpButtonStyle:
          requestHelpButtonStyle ?? this.requestHelpButtonStyle,
      emergencyCallButtonStyle:
          emergencyCallButtonStyle ?? this.emergencyCallButtonStyle,
      secondaryButtonStyle: secondaryButtonStyle ?? this.secondaryButtonStyle,
      dialogTitleStyle: dialogTitleStyle ?? this.dialogTitleStyle,
      dialogRadioStyle: dialogRadioStyle ?? this.dialogRadioStyle,
    );
  }

  @override
  ThemeExtension<RescueTheme> lerp(
    ThemeExtension<RescueTheme>? other,
    double t,
  ) {
    if (other is! RescueTheme) {
      return this;
    }

    return RescueTheme(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      coordinateCell: Color.lerp(coordinateCell, other.coordinateCell, t)!,
      placeIconColor: Color.lerp(placeIconColor, other.placeIconColor, t)!,
      requestHelpButton: Color.lerp(
        requestHelpButton,
        other.requestHelpButton,
        t,
      )!,
      requestHelpButtonText: Color.lerp(
        requestHelpButtonText,
        other.requestHelpButtonText,
        t,
      )!,
      requestHelpButtonShadow: Color.lerp(
        requestHelpButtonShadow,
        other.requestHelpButtonShadow,
        t,
      )!,
      secondaryButtonBackground: Color.lerp(
        secondaryButtonBackground,
        other.secondaryButtonBackground,
        t,
      )!,
      emergencyCallBorder: Color.lerp(
        emergencyCallBorder,
        other.emergencyCallBorder,
        t,
      )!,
      emergencyCallBackground: Color.lerp(
        emergencyCallBackground,
        other.emergencyCallBackground,
        t,
      )!,
      emergencyCallForeground: Color.lerp(
        emergencyCallForeground,
        other.emergencyCallForeground,
        t,
      )!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      // For text styles, we use the first theme's styles when t < 0.5,
      // otherwise use the other theme's styles
      coordinateCellStyle: t < 0.5
          ? coordinateCellStyle
          : other.coordinateCellStyle,
      coordinateDirectionStyle: t < 0.5
          ? coordinateDirectionStyle
          : other.coordinateDirectionStyle,
      descriptionStyle: t < 0.5 ? descriptionStyle : other.descriptionStyle,
      requestHelpButtonStyle: t < 0.5
          ? requestHelpButtonStyle
          : other.requestHelpButtonStyle,
      emergencyCallButtonStyle: t < 0.5
          ? emergencyCallButtonStyle
          : other.emergencyCallButtonStyle,
      secondaryButtonStyle: t < 0.5
          ? secondaryButtonStyle
          : other.secondaryButtonStyle,
      dialogTitleStyle: t < 0.5 ? dialogTitleStyle : other.dialogTitleStyle,
      dialogRadioStyle: t < 0.5 ? dialogRadioStyle : other.dialogRadioStyle,
    );
  }
}

/// Extension method to easily access RescueTheme from BuildContext
extension RescueThemeExtension on BuildContext {
  RescueTheme get rescueTheme => Theme.of(this).extension<RescueTheme>()!;
}
