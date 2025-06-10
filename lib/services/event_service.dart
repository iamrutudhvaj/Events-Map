import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event.dart';

class EventService {
  final String apiUrl =
      'https://6847d529ec44b9f3493e5f06.mockapi.io/api/v1/events';

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }
}
