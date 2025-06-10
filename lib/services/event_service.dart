import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event.dart';

class EventService {
  final String apiUrl =
      'https://run.mocky.io/v3/3c46da4a-c0e3-4ab4-8135-b176b2d4c835';

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
