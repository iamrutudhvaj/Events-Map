import 'dart:math';

class Event {
  final String name;
  final DateTime time;
  // Random location for map markers
  final double latitude;
  final double longitude;

  Event({
    required this.name,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      // Generate random coordinates since the API doesn't provide location data
      latitude: _generateRandomLat(),
      longitude: _generateRandomLng(),
    );
  }

  bool get isUpcoming => time.isAfter(DateTime.now());

  // Generate a random latitude (between 8 and 35 for reasonable map view in India)
  static double _generateRandomLat() {
    return 8.0 + (Random().nextDouble() * 27.0);
  }

  // Generate a random longitude (between 68 and 97 for reasonable map view in India)
  static double _generateRandomLng() {
    return 68.0 + (Random().nextDouble() * 29.0);
  }
}
