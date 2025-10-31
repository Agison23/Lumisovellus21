import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class RescuePage extends ConsumerStatefulWidget {
  const RescuePage({super.key});

  @override
  ConsumerState<RescuePage> createState() => _RescuePageState();
}

class _RescuePageState extends ConsumerState<RescuePage> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _selectedNeed;
  final Color _coordCellColor = const Color(0xdce53835);

  // Converts decimal degrees to degrees and minutes (DMM) with cardinal
  // direction key. For example: 37.422 -> (37, 25.320, 'north') for latitude.
  (int degrees, String minutesStr, String directionKey) _toDmm(
    double value, {
    required bool isLatitude,
  }) {
    final absVal = value.abs();
    final deg = absVal.floor();
    final minutes = (absVal - deg) * 60.0;
    final minutesFixed = minutes.toStringAsFixed(3);
    final minutesPadded = minutes < 10 ? '0$minutesFixed' : minutesFixed;
    final dirKey = value >= 0
        ? (isLatitude ? 'north' : 'east')
        : (isLatitude ? 'south' : 'west');
    return (deg, minutesPadded, dirKey);
  }

  // Gets the localized direction string from a direction key.
  String _getDirectionString(String directionKey, AppLocalizations localizations) {
    switch (directionKey) {
      case 'north':
        return localizations.coordinateDirectionNorth;
      case 'south':
        return localizations.coordinateDirectionSouth;
      case 'east':
        return localizations.coordinateDirectionEast;
      case 'west':
        return localizations.coordinateDirectionWest;
      default:
        return directionKey;
    }
  }

  Widget _coordCell(
    String text, {
    Alignment alignment = Alignment.center,
    double? minWidth,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 20, minWidth: minWidth ?? 0),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _coordCellColor,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _coordDirCell(String dir) {
    return Container(
      constraints: const BoxConstraints(minHeight: 20, minWidth: 48),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _coordCellColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        dir,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

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
    // Show dialog where the user selects a need and confirms sending help request
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            String? localSelectedNeed = _selectedNeed;
            var radioTextStyle = const TextStyle(fontSize: 16);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              actionsPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 12.0),
              title: Text(
                AppLocalizations.of(context).rescuePageIndicateNeed,
                style: const TextStyle(fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioGroup<String>(
                    groupValue: localSelectedNeed,
                    onChanged: (String? value) {
                      setLocalState(() {
                        localSelectedNeed = value;
                        _selectedNeed = value;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<String>(
                          title: Text(
                            AppLocalizations.of(context).rescuePageHealthIssue,
                            style: radioTextStyle,
                          ),
                          value: 'health',
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                        RadioListTile<String>(
                          title: Text(
                            AppLocalizations.of(
                              context,
                            ).rescuePageEquipmentIssue,
                            style: radioTextStyle,
                          ),
                          value: 'equipment',
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                        RadioListTile<String>(
                          title: Text(
                            AppLocalizations.of(context).rescuePageImLost,
                            style: radioTextStyle,
                          ),
                          value: 'lost',
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(AppLocalizations.of(context).dialogCancel),
                ),
                TextButton(
                  onPressed: localSelectedNeed == null
                      ? null
                      : () {
                          // TODO: send the actual help request with _selectedNeed
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${AppLocalizations.of(context).rescuePageRequestHelp} - ${_selectedNeed!}',
                              ),
                            ),
                          );
                        },
                  child: Text(AppLocalizations.of(context).dialogConfirm),
                ),
              ],
            );
          },
        );
      },
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.location_on,
                        //   color: Colors.red.shade500,
                        //   size: 20,
                        // ),
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
                      Builder(
                        builder: (context) {
                          final localizations = AppLocalizations.of(context);
                          final (latDeg, latMin, latDirKey) = _toDmm(
                            _currentPosition!.latitude,
                            isLatitude: true,
                          );
                          final (lonDeg, lonMin, lonDirKey) = _toDmm(
                            _currentPosition!.longitude,
                            isLatitude: false,
                          );
                          final latDir = _getDirectionString(latDirKey, localizations);
                          final lonDir = _getDirectionString(lonDirKey, localizations);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: _coordCell(
                                      '$latDeg°',
                                      alignment: Alignment.centerLeft,
                                      minWidth: 64,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: _coordCell(
                                      latMin,
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _coordDirCell(latDir),
                                  const SizedBox(width: 40),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: _coordCell(
                                      '$lonDeg°',
                                      alignment: Alignment.centerLeft,
                                      minWidth: 64,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: _coordCell(
                                      lonMin,
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _coordDirCell(lonDir),
                                  const SizedBox(width: 40),
                                ],
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: implement show on map
                                  },
                                  icon: Icon(Icons.place, color: Colors.red.shade500),
                                  label: const Text(
                                    'SHOW ON MAP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xfffafafa),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    side: BorderSide.none,
                                    shadowColor: Colors.transparent
                                  ),
                                ),
                              ),
                              const SizedBox(height: 0),
                              Text(
                                '${t.rescuePageCoordinateSystem}: WGS84',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${t.rescuePageAccuracy}: ${_currentPosition!.accuracy.toStringAsFixed(1)} m',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey.shade700),
                              ),
                            ],
                          );
                        },
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

              const SizedBox(height: 14),

              // Request help segment
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Help request description
                      Text(
                        t.rescuePageHelpRequestDescription,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 34),

                      // Request help button
                      Center(
                        child: GestureDetector(
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
                    const SizedBox(height: 12),
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
