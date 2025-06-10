import 'package:flutter/material.dart';
import 'package:map_interview_task/screens/map_screen/widgets/event_map.dart';

import '../../models/event.dart';
import '../../repositories/event_repository.dart';
import 'widgets/event_sheet.dart';
import 'widgets/filter_button_widget.dart';
import 'widgets/filter_modal_widget.dart';
import 'widgets/loading_error_handler.dart';

class EventsMapScreen extends StatefulWidget {
  const EventsMapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EventsMapScreenState();
}

class _EventsMapScreenState extends State<EventsMapScreen> {
  final EventRepository _eventRepository = EventRepository();
  final EventMapController _mapController = EventMapController();

  late Future<List<Event>> _eventsFuture;

  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _eventsFuture = _eventRepository.getEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = _eventRepository.getEvents();
    });
  }

  void _updateFilteredEvents(List<Event> filteredEvents) {
    if (mounted) {
      setState(() {
        _filteredEvents = List<Event>.from(filteredEvents);
      });
    }
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FutureBuilder<List<Event>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return FilterModalWidget(
              events: snapshot.data!,
              onFilteredEventsChanged: _updateFilteredEvents,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Explorer'),
        elevation: 0,
        actions: [
          // EventFilter dropdown in the app bar
          FilterButtonWidget(onPressed: () => _showFilterModal(context)),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          return LoadingErrorHandler(
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            error: snapshot.hasError ? snapshot.error : null,
            onRetry: _refreshEvents,
            child: _buildContent(snapshot.data ?? []),
          );
        },
      ),
    );
  }

  Widget _buildContent(List<Event> events) {
    // If we don't have filtered events yet, initialize them
    if (_filteredEvents.isEmpty && events.isNotEmpty) {
      // Set default to upcoming events
      _filteredEvents = _eventRepository.filterUpcomingEvents(events);
    }

    final String headerTitle = _getHeaderTitle();

    return Stack(
      children: [
        // Google Map in background
        EventMap(events: _filteredEvents, controller: _mapController),

        // Bottom sheet with event list
        EventSheet(
          events: _filteredEvents,
          onRefresh: _refreshEvents,
          headerTitle: headerTitle,
          onEventTap: (event) {
            // When an event is tapped, focus the map on it
            _mapController.focusOnEvent(event);
          },
        ),
      ],
    );
  }

  String _getHeaderTitle() {
    // Create a title based on the current filtered events
    if (_filteredEvents.isEmpty) {
      return 'Events';
    }

    final now = DateTime.now();
    bool hasPastEvents = _filteredEvents.any(
      (event) => event.time.isBefore(now),
    );
    bool hasUpcomingEvents = _filteredEvents.any(
      (event) => event.time.isAfter(now),
    );

    if (hasPastEvents && hasUpcomingEvents) {
      return 'All Events';
    } else if (hasPastEvents) {
      return 'Past Events';
    } else {
      return 'Upcoming Events';
    }
  }
}
