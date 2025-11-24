import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class LocateButton extends StatelessWidget {
  final VoidCallback onLocate;
  const LocateButton({required this.onLocate, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onLocate,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: const Icon(Icons.my_location, size: 18),
        ),
      ),
    );
  }
}

class PlacesButton extends StatelessWidget {
  final void Function(CameraOptions) onLocationSelected;
  const PlacesButton({required this.onLocationSelected, super.key});

  Map<String, CameraOptions> get _places => {
    'Pallastunturi': CameraOptions(
      center: Point(coordinates: Position(24.07, 68.06)),
      zoom: 12,
      pitch: 60,
      bearing: 0,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      elevation: 6,
      color: Colors.white,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => _places.keys
          .map((k) => PopupMenuItem<String>(value: k, child: Text(k)))
          .toList(),
      onSelected: (v) => onLocationSelected(_places[v]!),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: const Icon(Icons.travel_explore, size: 20),
        ),
      ),
    );
  }
}
