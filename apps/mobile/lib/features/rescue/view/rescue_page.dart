import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

import '../viewmodel/rescue_view_model.dart';
import 'widgets/emergency_call_widget.dart';
import 'widgets/help_request_widget.dart';
import 'widgets/location_display_widget.dart';
import 'widgets/responsive_layout.dart';

/// Main page for the rescue feature
/// Displays location, allows requesting help, and calling emergency services
class RescuePage extends ConsumerStatefulWidget {
  const RescuePage({super.key});

  @override
  ConsumerState<RescuePage> createState() => _RescuePageState();
}

class _RescuePageState extends ConsumerState<RescuePage> {
  @override
  Widget build(BuildContext context) {
    final rescueTheme = context.rescueTheme;
    final state = ref.watch(rescueViewModelProvider);
    final viewModel = ref.read(rescueViewModelProvider.notifier);
    final responsive = context.responsive;
    final localizations = AppLocalizations.of(context);

    final basePadding = responsive.scaleWidth(28.0);
    final verticalSpacing = responsive.scaleHeight(24.0);

    // Listen to errors and show snackbars
    ref.listen<String?>(rescueErrorProvider, (previous, next) {
      if (next != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: localizations.close,
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: rescueTheme.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: basePadding,
              right: basePadding,
              top: basePadding,
              bottom: basePadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: verticalSpacing),
                LocationDisplayWidget(
                  currentPosition: state.currentPosition,
                  isLoading: state.isLoadingLocation,
                ),
                SizedBox(height: verticalSpacing),
                HelpRequestWidget(
                  state: state,
                  viewModel: viewModel,
                ),
                SizedBox(height: responsive.scaleHeight(35)),
                const EmergencyCallWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
