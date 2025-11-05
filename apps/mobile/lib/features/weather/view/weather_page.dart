import 'package:flutter/material.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class WeatherPage extends StatefulWidget {

    const WeatherPage({super.key});
    
    @override
    State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  @override
  Widget build(BuildContext context) {
    final localised = AppLocalizations.of(context);

    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B487B),
              Color(0xFFB5C0E0),
              Color(0xFF1B487B)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                tabs: [
                  Tab(text: localised.dayBeforeYesterday),
                  Tab(text: localised.yesterday),
                  Tab(text: localised.now),
                ],
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    WeatherInfoCard(),
                    WeatherInfoCard(),
                    WeatherInfoCard(),
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

class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localised = AppLocalizations.of(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WeatherItem(
              icon: Icons.thermostat,
              label: localised.temperature,
              value: '3.7 °C',
            ),
            const SizedBox(height: 20),
            _WeatherItem(
              icon: Icons.ac_unit,
              label: localised.snowDepth,
              value: '0.0 cm',
            ),
            const SizedBox(height: 20),
            _WeatherItem(
              icon: Icons.air,
              label: localised.wind,
              value: '5.7 m/s',
              subLabel: 'South',
            ),
            const SizedBox(height: 20),
            _WeatherItem(
              icon: Icons.speed,
              label: localised.airPressure,
              value: '1012.7 mBar',
              subLabel: '${localised.trend} ↑',
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subLabel;

  const _WeatherItem({
    required this.icon,
    required this.label,
    required this.value,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 64, color: const Color.fromARGB(255, 130, 130, 130)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              if (subLabel != null)
                Text(subLabel!,
                    style: const TextStyle(fontSize: 18, color: Colors.blueGrey)),
            ],
          ),
        ),
      ],
    );
  }
}