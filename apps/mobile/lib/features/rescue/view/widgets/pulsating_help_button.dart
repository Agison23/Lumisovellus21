import 'package:flutter/material.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class PulsatingHelpButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isActive;

  const PulsatingHelpButton({
    super.key,
    required this.onTap,
    required this.isActive,
  });

  @override
  State<PulsatingHelpButton> createState() => _PulsatingHelpButtonState();
}

class _PulsatingHelpButtonState extends State<PulsatingHelpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.isActive) _controller.repeat();
  }

  @override
  void didUpdateWidget(PulsatingHelpButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _ring(double start, double end, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ).value;

        if (progress == 0) return const SizedBox.shrink();

        return Transform.scale(
          scale: 1 + progress * 0.5, // Reduced ring size
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity((1 - progress) * 0.25),
              border: Border.all(
                color: color.withOpacity((1 - progress) * 0.45),
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final rescueTheme = context.rescueTheme;
    final buttonColor = widget.isActive
        ? rescueTheme.requestHelpButton.withOpacity(0.9)
        : rescueTheme.requestHelpButton;

    return GestureDetector(
      key: const ValueKey('rescue.requestHelpButton'),
      onTap: widget.onTap,
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Allow rings to overflow visually
          children: [
            // Pulsating rings (only when active)
            if (widget.isActive) ...[
              _ring(0.00, 0.50, buttonColor),
              _ring(0.20, 0.70, buttonColor),
              _ring(0.40, 0.90, buttonColor),
            ],

            // The button itself (static, no animation)
            Container(
              width: 180,
              height: 180,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: buttonColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: rescueTheme.requestHelpButtonShadow,
                    spreadRadius: 14,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.isActive
                      ? 'End Event'
                      : t.rescuePageRequestHelp,
                  style: rescueTheme.requestHelpButtonStyle.copyWith(
                    color: rescueTheme.requestHelpButtonText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
