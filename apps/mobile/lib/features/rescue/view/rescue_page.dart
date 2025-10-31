import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/map/views/map_screen.dart';

class RescuePage extends ConsumerStatefulWidget {
  const RescuePage({super.key});

  @override
  ConsumerState<RescuePage> createState() => _RescuePageState();
}

class _RescuePageState extends ConsumerState<RescuePage> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _selectedNeed;

  // Converts decimal degrees to degrees and minutes (DMM) with cardinal
  // direction. For example: 37.422 -> (37, 25.320, 'N') for latitude.
  (int degrees, String minutesStr, String direction) _toDmm(
    double value, {
    required bool isLatitude,
  }) {
    final absVal = value.abs();
    final deg = absVal.floor();
    final minutes = (absVal - deg) * 60.0;
    final minutesFixed = minutes.toStringAsFixed(3);
    final minutesPadded = minutes < 10 ? '0$minutesFixed' : minutesFixed;
    final dir = value >= 0
        ? (isLatitude ? 'N' : 'E')
        : (isLatitude ? 'S' : 'W');
    return (deg, minutesPadded, dir);
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
        color: const Color(0xFF203A78),
        borderRadius: BorderRadius.circular(8),
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
        color: const Color(0xFF10265A),
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

  void _callForHelp() {
    // TODO: Implement actual rescue call functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).callForHelp),
        content: const Text(
          'Emergency call functionality will be implemented here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red.shade500,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          t.currentLocation,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    if (_isLoadingLocation)
                      const Center(child: CircularProgressIndicator())
                    else if (_currentPosition != null)
                      Builder(
                        builder: (context) {
                          final (latDeg, latMin, latDir) = _toDmm(
                            _currentPosition!.latitude,
                            isLatitude: true,
                          );
                          final (lonDeg, lonMin, lonDir) = _toDmm(
                            _currentPosition!.longitude,
                            isLatitude: false,
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                children: [
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
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
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
                                ],
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const MapScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.place),
                                  label: const Text(
                                    'SHOW ON MAP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D57C8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Coordinate system: WGS84',
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

              // const SizedBox(height: 5),

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
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 36),

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
                        onPressed: _callForHelp,
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
