import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'responsive_layout.dart';

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

  Widget _ring(double start, double end, Color color, double buttonSize) {
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
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: (1 - progress) * 0.25),
              border: Border.all(
                color: color.withValues(alpha: (1 - progress) * 0.45),
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
    final responsive = ResponsiveLayout(
      context: context,
      child: const SizedBox.shrink(),
    );

    // Responsive button size - use the smaller dimension to ensure it fits
    final buttonSize = responsive.minDimension * 0.50;
    final buttonPadding = responsive.scaleWidth(1.0); // Reduced from 8.0
    final shadowSpread = responsive.scaleWidth(14.0);
    final shadowBlur = responsive.scaleWidth(20.0);

    final buttonColor = widget.isActive
        ? rescueTheme.requestHelpButton.withValues(alpha: 0.9)
        : rescueTheme.requestHelpButton;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          key: const ValueKey('rescue.requestHelpButton'),
          onTap: widget.onTap,
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, // Allow rings to overflow visually
              children: [
                // Pulsating rings (only when active)
                if (widget.isActive) ...[
                  _ring(0.00, 0.50, buttonColor, buttonSize),
                  _ring(0.20, 0.70, buttonColor, buttonSize),
                  _ring(0.40, 0.90, buttonColor, buttonSize),
                ],

                // The button itself (static, no animation)
                Container(
                  width: buttonSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: rescueTheme.requestHelpButtonShadow,
                        spreadRadius: shadowSpread,
                        blurRadius: shadowBlur,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: buttonPadding),
                    child: AutoSizeText(
                      widget.isActive
                          ? t.rescuePageEndEvent
                          : t.rescuePageRequestHelp,
                      style: rescueTheme.requestHelpButtonStyle.copyWith(
                        color: rescueTheme.requestHelpButtonText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
