import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/event.dart';
import 'filter_header_widget.dart';

class EventSheet extends StatefulWidget {
  final List<Event> events;
  final VoidCallback onRefresh;
  final String headerTitle;
  final Function(Event)? onEventTap;

  const EventSheet({
    super.key,
    required this.events,
    required this.onRefresh,
    required this.headerTitle,
    this.onEventTap,
  });

  @override
  State<EventSheet> createState() => _EventSheetState();
}

class _EventSheetState extends State<EventSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            // We can add handling for scrolling notification if needed
            return false;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle and header part - these will be draggable now
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  FilterHeaderWidget(
                    title: widget.headerTitle,
                    onRefresh: widget.onRefresh,
                  ),
                  // Content part
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child:
                        widget.events.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                              controller: _scrollController,
                              itemCount: widget.events.length,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemBuilder: (context, index) {
                                if (index >= widget.events.length) {
                                  return null;
                                }
                                final event = widget.events[index];
                                return _buildEventCard(event);
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[500]),
          const SizedBox(height: 16),
          Text(
            'No events to display',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final isPast = event.time.isBefore(DateTime.now());

    return GestureDetector(
      onTap: () {
        // When an event card is tapped, call the onEventTap callback
        if (widget.onEventTap != null) {
          widget.onEventTap!(event);
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: const Color(0xFF303030),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date/Time indicator
              Container(
                width: 50,
                decoration: BoxDecoration(
                  color:
                      isPast
                          ? const Color(0xFF424242)
                          : const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Text(
                      dateFormat.format(event.time).split(' ')[0], // Month
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            isPast ? Colors.grey[300] : Colors.lightBlue[100],
                      ),
                    ),
                    Text(
                      event.time.day.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isPast ? Colors.grey[300] : Colors.lightBlue[100],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isPast ? Colors.grey[400] : Colors.lightBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeFormat.format(event.time),
                          style: TextStyle(
                            color:
                                isPast
                                    ? Colors.grey[400]
                                    : Colors.lightBlue[200],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Icon
              Icon(Icons.chevron_right, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }
}
