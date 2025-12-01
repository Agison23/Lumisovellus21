import 'package:auto_size_text/auto_size_text.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'responsive_layout.dart';

/// Widget that provides quick access to call emergency services.
class EmergencyCallWidget extends StatelessWidget {
  const EmergencyCallWidget({super.key});

  Future<void> _call112(BuildContext context) async {
    const String suomi112Package = 'fi.digia.suomi112';
    final Uri phoneUri = Uri(scheme: 'tel', path: '112');

    try {
      debugPrint('Attempting to launch 112 Suomi app...');
      var res = await LaunchApp.openApp(
        androidPackageName: suomi112Package,
        openStore: false,
      );

      if (res == 1) {
        debugPrint('Successfully launched 112 Suomi app');
        return;
      } else {
        debugPrint(
          'Failed to launch 112 Suomi app, falling back to phone dialer',
        );
      }
    } catch (e) {
      debugPrint(
        'Failed to launch 112 Suomi app: $e, falling back to phone dialer',
      );
    }

    try {
      debugPrint('Attempting to open phone dialer with 112');
      final bool launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        debugPrint('Successfully opened phone dialer with 112');
      } else {
        debugPrint('Failed to open phone dialer with 112');
      }
    } catch (e) {
      debugPrint('Failed to launch phone dialer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final rescueTheme = context.rescueTheme;
    final responsive = context.responsive;

    final sectionSpacing = responsive.scaleHeight(30.0);
    final borderRadius = responsive.scaleWidth(5.0);
    final shadowBlur = responsive.scaleWidth(4.0);
    final shadowOffset = responsive.scaleWidth(2.0);
    final buttonBorderRadius = responsive.scaleWidth(30.0);
    final iconSize = responsive.scaleWidth(50.0);
    final buttonHeight = responsive.scaleHeight(140.0);
    final borderWidth = responsive.scaleWidth(2.0);
    final basePadding = responsive.scaleWidth(28.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth =
            (constraints.maxWidth - (basePadding * 2)) / 2.5;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: rescueTheme.cardBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: rescueTheme.cardShadow,
                blurRadius: shadowBlur,
                offset: Offset(0, shadowOffset),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: sectionSpacing),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sectionSpacing),
                child: AutoSizeText(
                  t.rescuePageEmergencyCallDescription,
                  style: rescueTheme.descriptionStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 12,
                ),
              ),
              SizedBox(height: sectionSpacing),
              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () => _call112(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rescueTheme.emergencyCallBackground,
                    foregroundColor: rescueTheme.emergencyCallForeground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                    ),
                    side: BorderSide(
                      color: rescueTheme.emergencyCallBorder,
                      width: borderWidth,
                    ),
                    elevation: shadowBlur,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: iconSize),
                      SizedBox(width: sectionSpacing / 2),
                      AutoSizeText(
                        '112',
                        style: rescueTheme.emergencyCallButtonStyle,
                        maxLines: 1,
                        minFontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: sectionSpacing * 2),
            ],
          ),
        );
      },
    );
  }
}


