import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import '../data/model/weather_state.dart';
import '../viewmodel/weather_state_provider.dart';

class WeatherPage extends ConsumerStatefulWidget {

  const WeatherPage({super.key});
  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {

  @override
  Widget build(BuildContext context) {

    final localised = AppLocalizations.of(context);
    final String empty = localised.dataPointUnavailable;

    final WeatherState? weatherState = ref.watch(weatherStateProvider).value;

    List<String> windDirectionNames = [
                                        localised.north,
                                        localised.northeast,
                                        localised.east,
                                        localised.southeast,
                                        localised.south,
                                        localised.southwest,
                                        localised.west,
                                        localised.northwest,
                                      ];
    String windDirectionName = "";
    if(weatherState?.windDirection != null) {
      final double directionDegrees = weatherState!.windDirection!.toDouble();
      final int directionIndex = ((directionDegrees+22.5)/45.0).floor() % 8;
      windDirectionName = windDirectionNames[directionIndex];
    }
    

    return Container( // Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B487B),
              Color(0xFFB5C0E0),
              Color(0xFF6592C9)
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
              child: Container( // Round-cornered semitransparent decoration
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xD0FFFFFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                width: double.infinity,
                child: Column( // Vertical stack of weather aspect info-boxes
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( // Title "Recent weather"
                      localised.lastFewDaysWeather,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    WeatherBox(
                      title: localised.temperature,
                      subtitle: localised.lastThreeDays,
                      icon: Icons.thermostat,
                      children: [
                        WeatherLine(
                          label: localised.highest,
                          value: weatherState?.tempMax?.toStringAsFixed(1) ?? empty,
                          unit: localised.degreesCelsius
                        ),
                        WeatherLine(
                          label: localised.lowest,
                          value: weatherState?.tempMin?.toStringAsFixed(1) ?? empty,
                          unit: localised. degreesCelsius
                        ),
                        WeatherLine(
                          label: localised.countDaysAboveFreezing,
                          value: weatherState?.daysAboveZero?.toString() ?? empty,
                        )
                      ]
                    ),

                    const SizedBox(height: 16),

                    WeatherBox(
                      title: localised.wind,
                      subtitle: localised.lastThreeDays,
                      icon: Icons.air,
                      children: [
                        WeatherLine(
                          label: localised.avgSpeed,
                          value: weatherState?.windAvg?.toStringAsFixed(1) ?? empty,
                          unit: localised.metersPerSecond
                        ),
                        WeatherLine(
                          label: localised.maxWind,
                          value: weatherState?.windMax?.toStringAsFixed(1) ?? empty,
                          unit: localised.metersPerSecond
                        ),
                        WeatherLine(
                          label: localised.avgDirection,
                          value: weatherState?.windDirection != null ?
                            "$windDirectionName (${weatherState?.windDirection?.toStringAsFixed(0)} ${localised.degrees})"
                            : empty,
                        )
                      ]
                    ),

                    const SizedBox(height: 16),

                    WeatherBox(
                      title: localised.snowDepth,
                      subtitle: localised.lastSevenDays,
                      icon: Icons.ac_unit, // ac_unit looks like a snowflake as of 2025
                      children: [
                        WeatherLine(label: localised.snowDepthChange,
                        value: weatherState?.snowDepthChange?.toStringAsFixed(1) ?? empty)
                      ]
                    )     
                  ],
                ),
              ),
          )
        )
    );
  }
}

class WeatherBox extends StatelessWidget {

  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> children;

  const WeatherBox({
                      super.key,
                      required this.title,
                      required this.icon,
                      this.subtitle,
                      required this.children
                    });

  @override
  Widget build(BuildContext context) {

    return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column( // Title+subtitle+icon, followed by info rows
              children: [
                Row( // Title+subtitle+icon
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column( // icon
                      children: [
                        Icon(
                          icon,
                          size: 40,
                          color: Colors.grey.shade400,
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded( // title+subtitle
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                        ]
                      )
                    )
                    
                  ]
                ), // End of title+subtitle+icon
              
              const SizedBox(height: 8),
              
              Column(
                children: children
              )
              ]
            )
    );
  }
}

class WeatherLine extends StatelessWidget {
  
  final String label;
  final String value;
  final String? unit;

  const WeatherLine({
                super.key,
                required this.label,
                required this.value,
                this.unit
              });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          "$value ${unit ?? ""}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}