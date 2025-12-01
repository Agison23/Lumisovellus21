import 'package:flutter/material.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

/// Dialog for ending an active help event (cancel or complete)
class EndEventDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const EndEventDialog({
    super.key,
    required this.onCancel,
    required this.onComplete,
  });

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
        t.rescueEndEventDialogTitle,
        style: rescueTheme.dialogTitleStyle,
      ),
      content: Text(
        t.rescueEndEventDialogDescription,
        style: rescueTheme.dialogRadioStyle,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel();
          },
          child: Text(
            t.rescueEndEventDialogCancel,
            style: const TextStyle(color: Color.fromARGB(255, 172, 56, 48)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onComplete();
          },
          child: Text(
            t.rescueEndEventDialogComplete,
            style: const TextStyle(color: Color.fromARGB(255, 64, 147, 66)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.dialogCancel),
        ),
      ],
    );
  }
}

