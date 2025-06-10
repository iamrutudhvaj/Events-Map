import 'package:flutter/material.dart';

enum EventFilterOption { upcoming, past, all }

class EventFilter extends StatelessWidget {
  final EventFilterOption selectedFilter;
  final Function(EventFilterOption) onFilterChanged;

  const EventFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<EventFilterOption>(
        value: selectedFilter,
        icon: const Icon(Icons.filter_list),
        elevation: 16,
        underline: Container(
          height: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        onChanged: (EventFilterOption? newValue) {
          if (newValue != null) {
            onFilterChanged(newValue);
          }
        },
        items:
            EventFilterOption.values.map<DropdownMenuItem<EventFilterOption>>((
              EventFilterOption option,
            ) {
              return DropdownMenuItem<EventFilterOption>(
                value: option,
                child: Text(_getFilterText(option)),
              );
            }).toList(),
      ),
    );
  }

  String _getFilterText(EventFilterOption option) {
    switch (option) {
      case EventFilterOption.upcoming:
        return 'Upcoming Events';
      case EventFilterOption.past:
        return 'Past Events';
      case EventFilterOption.all:
        return 'All Events';
    }
  }
}
