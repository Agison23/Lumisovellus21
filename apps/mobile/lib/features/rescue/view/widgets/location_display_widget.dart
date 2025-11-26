import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/map/providers.dart';

/// Widget that displays the current location in DMM format
class LocationDisplayWidget extends ConsumerWidget {
  final Position? currentPosition;
  final bool isLoading;

  const LocationDisplayWidget({
    super.key,
    required this.currentPosition,
    required this.isLoading,
  });

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
  String _getDirectionString(
    String directionKey,
    AppLocalizations localizations,
  ) {
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
    BuildContext context,
    String text, {
    Alignment alignment = Alignment.center,
    double? minWidth,
  }) {
    final rescueTheme = context.rescueTheme;
    return Container(
      constraints: BoxConstraints(minHeight: 20, minWidth: minWidth ?? 0),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: rescueTheme.coordinateCell,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: rescueTheme.coordinateCellStyle),
    );
  }

  Widget _coordDirCell(BuildContext context, String dir) {
    final rescueTheme = context.rescueTheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 20, minWidth: 48),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: rescueTheme.coordinateCell,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(dir, style: rescueTheme.coordinateDirectionStyle),
    );
  }

  void _handleShowOnMap(WidgetRef ref) {
    // Signal the map to snap to location (this will also navigate to map if needed)
    ref.read(snapToLocationProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final rescueTheme = context.rescueTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Text(
                t.currentLocation,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (currentPosition != null)
            Builder(
              builder: (context) {
                final localizations = AppLocalizations.of(context);
                final (latDeg, latMin, latDirKey) = _toDmm(
                  currentPosition!.latitude,
                  isLatitude: true,
                );
                final (lonDeg, lonMin, lonDirKey) = _toDmm(
                  currentPosition!.longitude,
                  isLatitude: false,
                );
                final latDir = _getDirectionString(
                  latDirKey,
                  localizations,
                );
                final lonDir = _getDirectionString(
                  lonDirKey,
                  localizations,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 40),
                        Expanded(
                          child: _coordCell(
                            context,
                            '$latDeg°',
                            alignment: Alignment.centerLeft,
                            minWidth: 64,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _coordCell(
                            context,
                            latMin,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _coordDirCell(context, latDir),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 40),
                        Expanded(
                          child: _coordCell(
                            context,
                            '$lonDeg°',
                            alignment: Alignment.centerLeft,
                            minWidth: 64,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _coordCell(
                            context,
                            lonMin,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _coordDirCell(context, lonDir),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${t.rescuePageAccuracy}: ${currentPosition!.accuracy.toStringAsFixed(1)} m',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(
                      child: ElevatedButton.icon(
                        onPressed: currentPosition != null
                            ? () => _handleShowOnMap(ref)
                            : null,
                        icon: Icon(
                          Icons.place,
                          color: rescueTheme.requestHelpButton,
                        ),
                        label: Text(
                          t.rescuePageShowOnMap.toUpperCase(),
                          style: rescueTheme.secondaryButtonStyle,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rescueTheme.secondaryButtonBackground,
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide.none,
                          shadowColor: Colors.transparent,
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          else
            Text(
              t.locationNotAvailable,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }
}

