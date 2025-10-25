import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

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

    // TODO: Implement actual help request functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).rescuePageRequestHelp),
        content: Text(
          'Help request for $_selectedNeed will be sent to nearby rescuers.',
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

  Widget _buildNeedButton(BuildContext context, String text, String value) {
    final isSelected = _selectedNeed == value;

    return GestureDetector(
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
      backgroundColor: Colors.white,
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
                      color: Colors.grey.shade400,
                      blurRadius: 8,
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
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(12),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.grey.shade400,
                  //       blurRadius: 8,
                  //       offset: const Offset(0, 2),
                  //     ),
                  //   ],
                  // ),
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
                      const SizedBox(height: 32),

                      // Request help button
                      Center(
                        child: GestureDetector(
                          onTap: _requestHelp,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.shade300,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                t.rescuePageRequestHelp,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
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
                      blurRadius: 8,
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
                      width: 120,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _callForHelp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 24),
                            SizedBox(width: 12),
                            Text(
                              '112',
                              style: TextStyle(
                                fontSize: 18,
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
