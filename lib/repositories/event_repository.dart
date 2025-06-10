import '../models/event.dart';
import '../services/event_service.dart';

class EventRepository {
  final EventService _eventService = EventService();

  Future<List<Event>> getEvents() async {
    return await _eventService.fetchEvents();
  }

  List<Event> filterUpcomingEvents(List<Event> events) {
    final now = DateTime.now();
    return events.where((event) => event.time.isAfter(now)).toList();
  }

  List<Event> filterPastEvents(List<Event> events) {
    final now = DateTime.now();
    return events.where((event) => event.time.isBefore(now)).toList();
  }
}
