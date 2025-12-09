import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/map/providers.dart';
import 'responsive_layout.dart';

const double _coordinateBorderRadiusBase = 18.0;

/// Widget that displays the current location in DMM format
class LocationDisplayWidget extends ConsumerWidget {
  final Position? currentPosition;
  final bool isLoading;

  const LocationDisplayWidget({
    super.key,
    required this.currentPosition,
    required this.isLoading,
  });

  // Converts decimal degrees to degrees and minutes (DMM)
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

  // Safe converter: returns null if position is not available
  (int, String, String)? _safeToDmm(Position? pos, {required bool lat}) {
    if (pos == null) return null;
    return _toDmm(lat ? pos.latitude : pos.longitude, isLatitude: lat);
  }

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

  Widget _coordinateCell({
    required ResponsiveLayout responsive,
    required TextStyle textStyle,
    required Color backgroundColor,
    required String text,
    double? minWidth,
  }) {
    final cellPadding = EdgeInsets.symmetric(
      horizontal: responsive.scaleWidth(12.0),
      vertical: responsive.scaleHeight(8.0),
    );
    final minCellHeight = responsive.scaleHeight(20.0);
    final minCellWidth = minWidth ?? responsive.scaleWidth(54.0);
    final borderRadius = responsive.scaleWidth(_coordinateBorderRadiusBase);

    return Container(
      constraints: BoxConstraints(
        minHeight: minCellHeight,
        minWidth: minCellWidth,
      ),
      alignment: Alignment.center,
      padding: cellPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: AutoSizeText(
        text,
        style: textStyle,
        maxLines: 1,
        minFontSize: 10,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCoordinateRow({
    required ResponsiveLayout responsive,
    required double cellSpacing,
    required String degrees,
    required String minutes,
    required String direction,
    required double minDegreesWidth,
    required double minDirectionWidth,
    required TextStyle valueStyle,
    required TextStyle directionStyle,
    required Color backgroundColor,
  }) {
    final directionCell = _coordinateCell(
      responsive: responsive,
      textStyle: directionStyle,
      backgroundColor: backgroundColor,
      text: direction,
      minWidth: minDirectionWidth,
    );

    return Row(
      children: [
        Expanded(
          child: _coordinateCell(
            responsive: responsive,
            textStyle: valueStyle,
            backgroundColor: backgroundColor,
            text: '$degrees°',
            minWidth: minDegreesWidth,
          ),
        ),
        SizedBox(width: cellSpacing),
        Expanded(
          flex: 2,
          child: _coordinateCell(
            responsive: responsive,
            textStyle: valueStyle,
            backgroundColor: backgroundColor,
            text: minutes,
          ),
        ),
        SizedBox(width: cellSpacing),
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minDirectionWidth,
          ),
          child: directionCell,
        ),
      ],
    );
  }

  void _handleShowOnMap(WidgetRef ref) {
    ref.read(snapToLocationProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final rescueTheme = context.rescueTheme;
    final responsive = ResponsiveLayout(
      context: context,
      child: const SizedBox.shrink(),
    );

    // Convert coordinates or fallback to null
    final lat = _safeToDmm(currentPosition, lat: true);
    final lon = _safeToDmm(currentPosition, lat: false);

    // Final printable values with "?" fallback
    final localizations = AppLocalizations.of(context);

    final latDeg = lat?.$1.toString() ?? '?';
    final latMin = lat?.$2 ?? '?';
    final latDir = lat != null
        ? _getDirectionString(lat.$3, localizations)
        : '?';

    final lonDeg = lon?.$1.toString() ?? '?';
    final lonMin = lon?.$2 ?? '?';
    final lonDir = lon != null
        ? _getDirectionString(lon.$3, localizations)
        : '?';

    // Responsive sizing
    final horizontalPadding = responsive.scaleWidth(12.0);
    final cellSpacing = responsive.scaleWidth(16.0);
    final verticalSpacing = responsive.scaleHeight(8.0);
    final buttonPadding = EdgeInsets.symmetric(
      vertical: responsive.scaleHeight(12.0),
      horizontal: responsive.scaleWidth(12.0),
    );
    final minDegreesWidth = responsive.scaleWidth(120.0);
    final minDirectionWidth = responsive.scaleWidth(80.0);
    final iconSize = responsive.scaleWidth(40.0);
    final buttonBorderRadius = responsive.scaleWidth(8.0);
    final maxContentWidth = responsive.scaleWidth(520.0);
    final minContentWidth = responsive.scaleWidth(260.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: responsive.scaleHeight(20.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: cellSpacing),
                  AutoSizeText(
                    t.currentLocation,
                    style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ) ??
                        const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    minFontSize: 16,
                  ),
                ],
              ),

              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxContentWidth,
                    minWidth: minContentWidth,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCoordinateRow(
                        responsive: responsive,
                        cellSpacing: cellSpacing,
                        degrees: latDeg,
                        minutes: latMin,
                        direction: latDir,
                        minDegreesWidth: minDegreesWidth,
                        minDirectionWidth: minDirectionWidth,
                        valueStyle: rescueTheme.coordinateCellStyle,
                        directionStyle: rescueTheme.coordinateDirectionStyle,
                        backgroundColor: rescueTheme.coordinateCell,
                      ),

                      SizedBox(height: cellSpacing),

                      _buildCoordinateRow(
                        responsive: responsive,
                        cellSpacing: cellSpacing,
                        degrees: lonDeg,
                        minutes: lonMin,
                        direction: lonDir,
                        minDegreesWidth: minDegreesWidth,
                        minDirectionWidth: minDirectionWidth,
                        valueStyle: rescueTheme.coordinateCellStyle,
                        directionStyle: rescueTheme.coordinateDirectionStyle,
                        backgroundColor: rescueTheme.coordinateCell,
                      ),

                      SizedBox(height: verticalSpacing * 2),

                      // Accuracy with fallback
                      AutoSizeText(
                        '${t.rescuePageAccuracy}: '
                        '${currentPosition?.accuracy.toStringAsFixed(1) ?? '?'} m',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color:
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                            ) ??
                            TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        maxLines: 1,
                        minFontSize: 10,
                      ),

                      // Show on Map Button
                      SizedBox(
                        child: ElevatedButton.icon(
                          onPressed: currentPosition != null
                              ? () => _handleShowOnMap(ref)
                              : null,
                          icon: Icon(
                            Icons.place,
                            color: rescueTheme.placeIconColor,
                            size: iconSize,
                          ),
                          label: AutoSizeText(
                            t.rescuePageShowOnMap.toUpperCase(),
                            style: rescueTheme.secondaryButtonStyle,
                            maxLines: 1,
                            minFontSize: 10,
                          ),
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                    rescueTheme.secondaryButtonBackground,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                                padding: buttonPadding,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    buttonBorderRadius,
                                  ),
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
