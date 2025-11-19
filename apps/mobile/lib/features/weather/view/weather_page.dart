import 'package:flutter/material.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class WeatherPage extends StatelessWidget {

  const WeatherPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final localised = AppLocalizations.of(context);

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
          child:
            Center(
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
                      icon: Icons.thermostat
                    ),

                    const SizedBox(height: 16),

                    WeatherBox(
                      title: localised.wind,
                      subtitle: localised.lastThreeDays,
                      icon: Icons.air
                    ),

                    const SizedBox(height: 16),

                    WeatherBox(
                      title: localised.snowDepth,
                      subtitle: localised.lastSevenDays,
                      icon: Icons.ac_unit // ac_unit looks like a snowflake as of 2025
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

  const WeatherBox({
                      super.key,
                      required this.title,
                      required this.icon,
                      this.subtitle
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                        ]
                      )
                    )
                    
                  ]
                ), // End of title+subtitle+icon
              
              // Start of info rows
              
              const SizedBox(height: 8),

              // --- Maximum Row ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maximum",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "11°C",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              const Divider(thickness: 2, height: 4),

              // --- Average Row ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Average",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "5°C",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              const Divider(thickness: 2, height: 4),

              // --- Minimum Row ---
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Minimum",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "2°C",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // End of info rows
              ]
            )
    );
  }
}