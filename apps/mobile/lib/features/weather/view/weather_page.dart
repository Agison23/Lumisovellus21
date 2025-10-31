import 'package:flutter/material.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class WeatherPage extends StatefulWidget {

    const WeatherPage({super.key});
    static const int today = 2; // Index of "Today" out of day selection buttons
    
    @override
    State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int selectedDay = WeatherPage.today;

  @override
  Widget build(BuildContext context) {
    final localised = AppLocalizations.of(context);
    final List<String> dayButtonTexts = [
      localised.dayBeforeYesterday,
      localised.yesterday,
      localised.now
    ];

    return SafeArea(
      child: Column(
        children: [
          ToggleButtons(
            direction: Axis.horizontal,
            isSelected: List<bool>.generate(3, (buttonIndex) => buttonIndex == selectedDay),
            children: List<Widget>.generate(3, (buttonIndex) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  dayButtonTexts[buttonIndex],
                  style: const TextStyle(fontSize: 20)),
              );
            }),
            onPressed: (int index) {
              setState(() {
                selectedDay = index;
              });
            }
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 500,
            color: Colors.lightBlue,
            child: const Center(
              child: Text(
                "Weather Display Placeholder",
                style: TextStyle(fontSize: 20),
              ),
            )
          )
        ]
      ),
    );
  }
}