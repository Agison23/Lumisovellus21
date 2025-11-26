import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import '../viewmodel/rescue_view_model.dart';
import 'widgets/location_display_widget.dart';
import 'widgets/help_request_dialog.dart';
import 'widgets/end_event_dialog.dart';
import 'widgets/pulsating_help_button.dart';

/// Main page for the rescue feature
/// Displays location, allows requesting help, and calling emergency services
class RescuePage extends ConsumerWidget {
  const RescuePage({super.key});

  Future<void> _call112(BuildContext context) async {
    const String suomi112Package = 'fi.digia.suomi112';
    final Uri phoneUri = Uri(scheme: 'tel', path: '112');
    // Try to launch the 112 Suomi app using external_app_launcher
    try {
      debugPrint('Attempting to launch 112 Suomi app...');
      var res = await LaunchApp.openApp(
        androidPackageName: suomi112Package,
        openStore: false, // Don't open Play Store if app is not installed
      );

      if (res == 1) {
        debugPrint('Successfully launched 112 Suomi app');
        return; // Successfully launched 112 Suomi app
      } else {
        debugPrint(
          'Failed to launch 112 Suomi app, falling back to phone dialer',
        );
      }
    } catch (e) {
      // App is not installed or cannot be launched
      debugPrint(
        'Failed to launch 112 Suomi app: $e, falling back to phone dialer',
      );
    }

    bool launchedCorrectly = false;
    // Fallback: open phone dialer with 112
    try {
      debugPrint('Attempting to open phone dialer with 112');
      final bool launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        debugPrint('Successfully opened phone dialer with 112');
        launchedCorrectly = true;
      } else {
        debugPrint('Failed to open phone dialer with 112');
      }
    } catch (e) {
      debugPrint('Failed to launch phone dialer: $e');
    }
  }

  void _handleHelpButtonTap(
    BuildContext context,
    RescueState state,
    RescueViewModel viewModel,
  ) {
    if (state.hasActiveEvent) {
      // Show dialog to end the event
      showDialog(
        context: context,
        builder: (dialogContext) => EndEventDialog(
          onCancel: () async {
            await viewModel.cancelHelpEvent();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help event cancelled')),
              );
            }
          },
          onComplete: () async {
            await viewModel.completeHelpEvent();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help event completed')),
              );
            }
          },
        ),
      );
    } else {
      // Show dialog to request help
      showDialog(
        context: context,
        builder: (dialogContext) => HelpRequestDialog(
          onConfirm: (needType) async {
            await viewModel.requestHelp(needType);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final rescueTheme = context.rescueTheme;
    final state = ref.watch(rescueViewModelProvider);
    final viewModel = ref.read(rescueViewModelProvider.notifier);

    // Listen for error messages
    ref.listen<String?>(rescueViewModelProvider.select((s) => s.errorMessage), (
      previous,
      next,
    ) {
      if (next != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: rescueTheme.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Location information segment
              LocationDisplayWidget(
                currentPosition: state.currentPosition,
                isLoading: state.isLoadingLocation,
              ),

              const SizedBox(height: 20),

              // Help request card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: rescueTheme.cardShadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Help request description
                    Text(
                      t.rescuePageHelpRequestDescription,
                      style: rescueTheme.descriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 34),

                    // Pulsating help button
                    PulsatingHelpButton(
                      onTap: () =>
                          _handleHelpButtonTap(context, state, viewModel),
                      isActive: state.hasActiveEvent
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Call 112 segment
              Container(
                decoration: BoxDecoration(
                  color: rescueTheme.cardBackground,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: rescueTheme.cardShadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t.rescuePageEmergencyCallDescription,
                            style: rescueTheme.descriptionStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 170,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => _call112(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rescueTheme.emergencyCallBackground,
                          foregroundColor: rescueTheme.emergencyCallForeground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: BorderSide(
                            color: rescueTheme.emergencyCallBorder,
                            width: 2,
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              '112',
                              style: rescueTheme.emergencyCallButtonStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}
