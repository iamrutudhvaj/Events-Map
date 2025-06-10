import 'package:flutter/material.dart';

import '../../../models/event.dart';
import 'event_filter.dart';

class EventFilterWidget extends StatefulWidget {
  final List<Event> events;
  final Function(List<Event>) onFilteredEventsChanged;

  const EventFilterWidget({
    super.key,
    required this.events,
    required this.onFilteredEventsChanged,
  });

  @override
  State<EventFilterWidget> createState() => _EventFilterWidgetState();
}

class _EventFilterWidgetState extends State<EventFilterWidget> {
  EventFilterOption _selectedFilter = EventFilterOption.upcoming;

  void _applyFilter() {
    final filteredEvents = _filterEvents(widget.events, _selectedFilter);
    widget.onFilteredEventsChanged(filteredEvents);
  }

  void _onFilterChanged(EventFilterOption newFilter) {
    setState(() {
      _selectedFilter = newFilter;
    });
    // Filter will only be applied when Apply Filter button is clicked
  }

  List<Event> _filterEvents(List<Event> events, EventFilterOption filter) {
    final now = DateTime.now();

    switch (filter) {
      case EventFilterOption.upcoming:
        return events.where((event) => event.time.isAfter(now)).toList();
      case EventFilterOption.past:
        return events.where((event) => event.time.isBefore(now)).toList();
      case EventFilterOption.all:
        return List.from(events); // Return all events
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filter by:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            EventFilter(
              selectedFilter: _selectedFilter,
              onFilterChanged: _onFilterChanged,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            _applyFilter();
            Navigator.pop(context);
          },
          child: const Text('Apply Filter'),
        ),
      ],
    );
  }
}
