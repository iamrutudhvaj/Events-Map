import 'package:flutter/material.dart';
import '../../../models/event.dart';
import 'event_filter_widget.dart';

class FilterModalWidget extends StatelessWidget {
  final List<Event> events;
  final Function(List<Event>) onFilteredEventsChanged;

  const FilterModalWidget({
    super.key,
    required this.events,
    required this.onFilteredEventsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EventFilterWidget(
            events: events,
            onFilteredEventsChanged: onFilteredEventsChanged,
          ),
        ],
      ),
    );
  }
}
