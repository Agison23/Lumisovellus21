import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:lumisovellus/features/rescue/model/help_models.dart';
import 'package:lumisovellus/features/rescue/data/help_service_provider.dart';

class RescuePage extends ConsumerStatefulWidget {
  const RescuePage({super.key});

  @override
  ConsumerState<RescuePage> createState() => _RescuePageState();
}

class _RescuePageState extends ConsumerState<RescuePage> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _selectedNeed;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _call112(BuildContext context) async {
    const String suomi112Package = 'fi.digia.suomi112';
    final Uri phoneUri = Uri(scheme: 'tel', path: '112');
    // Try to launch the 112 Suomi app using external_app_launcher
    try {
      debugPrint('Attempting to launch 112 Suomi app...');
      await LaunchApp.openApp(
        androidPackageName: suomi112Package,
        openStore: false, // Don't open Play Store if app is not installed
      );
      debugPrint('Successfully launched 112 Suomi app');
      return; // Successfully launched 112 Suomi app
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

    if (!launchedCorrectly) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).rescuePageEmergencyCallFailed,
            ),
          ),
        );
      }
    }
  }

  void _requestHelp() {
    if (_selectedNeed == null) {
      // Show error if no need is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).rescuePageIndicateNeed),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Confirm and dispatch help request via HelpService (testable)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(
          20.0,
          16.0,
          20.0,
          0.0,
        ), // reduced bottom,
        actionsPadding: const EdgeInsets.fromLTRB(
          20.0,
          0.0,
          20.0,
          0.0,
        ), // reduced bottom,
        content: Text(
          AppLocalizations.of(context).rescuePageRequestHelpConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).dialogCancel),
            key: const ValueKey('rescue.confirm.cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final service = ref.read(helpServiceProvider);
              final needType = _selectedNeed == 'health'
                  ? HelpNeedType.health
                  : _selectedNeed == 'equipment'
                  ? HelpNeedType.equipment
                  : HelpNeedType.lost;
              try {
                final resp = await service.requestHelp(
                  HelpRequest(
                    needType: needType,
                    latitude: _currentPosition?.latitude,
                    longitude: _currentPosition?.longitude,
                    accuracyMeters: _currentPosition?.accuracy,
                  ),
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppLocalizations.of(context).rescuePageRequestHelp}: ${resp.message ?? 'sent'}',
                    ),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(
                        context,
                      ).rescuePageEmergencyCallFailed,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(AppLocalizations.of(context).dialogConfirm),
            key: const ValueKey('rescue.confirm.ok'),
          ),
        ],
      ),
    );
  }

  Widget _buildNeedButton(BuildContext context, String text, String value) {
    final isSelected = _selectedNeed == value;

    return GestureDetector(
      key: ValueKey('rescue.need.$value'),
      onTap: () {
        setState(() {
          _selectedNeed = value;
        });
      },
      child: Container(
        height: 56, // Increased height to accommodate longer text
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ), // Reduced horizontal padding
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.red.shade600 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.red.shade700 : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 11, // Slightly smaller font size
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFAFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Location information segment
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red.shade500,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          t.currentLocation,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingLocation)
                      const Center(child: CircularProgressIndicator())
                    else if (_currentPosition != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${t.rescuePageLatitude}: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${t.rescuePageLongitude}: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${t.rescuePageAccuracy}: ${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      )
                    else
                      Text(
                        t.locationNotAvailable,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // Request help segment
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Help request description
                        Text(
                          t.rescuePageHelpRequestDescription,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        // Please indicate your need
                        Text(
                          t.rescuePageIndicateNeed,
                          // style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          //   fontWeight: FontWeight.bold,
                          // ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),

                        // Need selection buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildNeedButton(
                                context,
                                t.rescuePageHealthIssue,
                                'health',
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildNeedButton(
                                context,
                                t.rescuePageEquipmentIssue,
                                'equipment',
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildNeedButton(
                                context,
                                t.rescuePageImLost,
                                'lost',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Request help button
                        Center(
                          child: GestureDetector(
                            key: const ValueKey('rescue.requestHelpButton'),
                            onTap: _requestHelp,
                            child: Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53935),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade800,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ), // add horizontal padding
                                  child: Text(
                                    t.rescuePageRequestHelp,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Call 112 segment
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
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
                        Expanded(
                          child: Text(
                            t.rescuePageEmergencyCallDescription,
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 170,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => _call112(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.red.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: Colors.red.shade400,
                            width: 2,
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 28),
                            SizedBox(width: 12),
                            Text(
                              '112',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
