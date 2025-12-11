import 'package:flutter/material.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import '../../domain/models/help_need_type.dart';

/// Dialog for requesting help with need type selection
class HelpRequestDialog extends StatefulWidget {
  final Function(HelpNeedType) onConfirm;

  const HelpRequestDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<HelpRequestDialog> createState() => _HelpRequestDialogState();
}

class _HelpRequestDialogState extends State<HelpRequestDialog> {
  String? _selectedNeed;

  @override
  Widget build(BuildContext context) {
    final rescueTheme = context.rescueTheme;
    final t = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
      actionsPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 12.0),
      title: Text(
        t.rescuePageIndicateNeed,
        style: rescueTheme.dialogTitleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioMenuButton<String>(
            value: 'health',
            groupValue: _selectedNeed,
            onChanged: (value) {
              setState(() {
                _selectedNeed = value;
              });
            },
            child: Text(
              t.rescuePageHealthIssue,
              style: rescueTheme.dialogRadioStyle,
            ),
          ),
          RadioMenuButton<String>(
            value: 'equipment',
            groupValue: _selectedNeed,
            onChanged: (value) {
              setState(() {
                _selectedNeed = value;
              });
            },
            child: Text(
              t.rescuePageEquipmentIssue,
              style: rescueTheme.dialogRadioStyle,
            ),
          ),
          RadioMenuButton<String>(
            value: 'lost',
            groupValue: _selectedNeed,
            onChanged: (value) {
              setState(() {
                _selectedNeed = value;
              });
            },
            child: Text(
              t.rescuePageImLost,
              style: rescueTheme.dialogRadioStyle,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const ValueKey('rescue.confirm.cancel'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.dialogCancel),
        ),
        TextButton(
          key: const ValueKey('rescue.confirm.ok'),
          onPressed: _selectedNeed == null
              ? null
              : () {
                  final needType = _selectedNeed == 'health'
                      ? HelpNeedType.health
                      : _selectedNeed == 'equipment'
                          ? HelpNeedType.equipment
                          : HelpNeedType.lost;
                  Navigator.of(context).pop();
                  widget.onConfirm(needType);
                },
          child: Text(t.dialogConfirm),
        ),
      ],
    );
  }
}
