import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

import '../../viewmodel/rescue_view_model.dart';
import 'end_event_dialog.dart';
import 'help_request_dialog.dart';
import 'pulsating_help_button.dart';
import 'responsive_layout.dart';

/// Widget that allows the user to request help or manage an active event.
class HelpRequestWidget extends StatelessWidget {
  final RescueState state;
  final RescueViewModel viewModel;

  const HelpRequestWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  void _handleHelpButtonTap(BuildContext context) {
    final t = AppLocalizations.of(context);
    if (state.hasActiveEvent) {
      showDialog(
        context: context,
        builder: (dialogContext) => EndEventDialog(
          onCancel: () async {
            await viewModel.cancelHelpEvent(t);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.rescueEndEventDialogCancel),
                  action: SnackBarAction(
                    label: t.close,
                    onPressed: () {},
                  ),
                ),
              );
            }
          },
          onComplete: () async {
            await viewModel.completeHelpEvent(t);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.rescueEndEventDialogComplete),
                  action: SnackBarAction(
                    label: t.close,
                    onPressed: () {},
                  ),
                ),
              );
            }
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) => HelpRequestDialog(
          onConfirm: (needType) async {
            await viewModel.requestHelp(needType, t);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final rescueTheme = context.rescueTheme;
    final responsive = context.responsive;

    final sidePadding = responsive.scaleWidth(45.0);
    final borderRadius = responsive.scaleWidth(5.0);
    final shadowBlur = responsive.scaleWidth(4.0);
    final shadowOffset = responsive.scaleWidth(2.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: sidePadding,
        right: sidePadding,
        top: responsive.scaleWidth(60.0),
        bottom: responsive.scaleWidth(200.0),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
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
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: responsive.scaleHeight(30.0),
        children: [
          AutoSizeText(
            t.rescuePageHelpRequestDescription,
            style: rescueTheme.descriptionStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
            minFontSize: 12,
          ),
          SizedBox(height: responsive.scaleHeight(90.0)),
          PulsatingHelpButton(
            onTap: () => _handleHelpButtonTap(context),
            isActive: state.hasActiveEvent,
          ),
        ],
      ),
    );
  }
}


