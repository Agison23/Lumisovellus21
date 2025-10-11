import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapStyleProvider = FutureProvider<String>((ref) async {
  return await rootBundle.loadString('assets/styles/terrain.json');
});