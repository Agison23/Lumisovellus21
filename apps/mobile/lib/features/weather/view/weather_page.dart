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
  num maxTemperature = 0.0;

  @override
  Widget build(BuildContext context) {

    final localised = AppLocalizations.of(context);
    const String empty = "XX";

    final WeatherState? weatherState = ref.watch(weatherStateProvider).value;
    final bool gotState = ref.watch(weatherStateProvider).hasValue;

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
                        WeatherLine(label: localised.highest, value: gotState ? weatherState!.tempMax.toString() : empty),
                        WeatherLine(label: localised.lowest, value: gotState ? weatherState!.tempMin.toString() : empty),
                        WeatherLine(label: localised.countDaysAboveFreezing, value: gotState ? weatherState!.daysAboveZero.toString() : empty)
                      ]
                    ),

                    const SizedBox(height: 16),

                    WeatherBox(
                      title: localised.wind,
                      subtitle: localised.lastThreeDays,
                      icon: Icons.air,
                      children: [
                        WeatherLine(label: localised.avgSpeed, value: "333 m/s"),
                        WeatherLine(label: localised.maxWind, value: "888 m/s"),
                        WeatherLine(label: localised.avgDirection, value: "${localised.south} (184 °)")
                      ]
                    ),

                    const SizedBox(height: 16),

                    WeatherBox(
                      title: localised.snowDepth,
                      subtitle: localised.lastSevenDays,
                      icon: Icons.ac_unit, // ac_unit looks like a snowflake as of 2025
                      children: [
                        WeatherLine(label: localised.snowDepthChange, value: "+222 cm")
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

  const WeatherLine({
                super.key,
                required this.label,
                required this.value
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
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}