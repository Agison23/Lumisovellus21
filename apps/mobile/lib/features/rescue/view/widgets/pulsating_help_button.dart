import 'package:flutter/material.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

/// A pulsating circular button for requesting help
class PulsatingHelpButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isActive;
  final bool isLoading;

  const PulsatingHelpButton({
    super.key,
    required this.onTap,
    required this.isActive,
    this.isLoading = false,
  });

  @override
  State<PulsatingHelpButton> createState() => _PulsatingHelpButtonState();
}

class _PulsatingHelpButtonState extends State<PulsatingHelpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsatingHelpButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final rescueTheme = context.rescueTheme;

    return GestureDetector(
      key: const ValueKey('rescue.requestHelpButton'),
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Container(
            width: 180,
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.isActive
                  ? rescueTheme.requestHelpButton.withOpacity(0.9)
                  : rescueTheme.requestHelpButton,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: rescueTheme.requestHelpButtonShadow,
                  spreadRadius: widget.isActive ? 14 * _scaleAnimation.value : 14,
                  blurRadius: widget.isActive ? 20 * _scaleAnimation.value : 20,
                ),
              ],
            ),
            child: widget.isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Padding(
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
          );
        },
      ),
    );
  }
}

