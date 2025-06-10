import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../models/event.dart';

// A controller that can be passed around to focus the map on specific events
class EventMapController {
  GoogleMapController? _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void focusOnEvent(Event event) {
    if (_mapController == null) return;

    final LatLng position = LatLng(event.latitude, event.longitude);
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 12.0, // Higher zoom level to focus on the event
        ),
      ),
    );
  }
}

class EventMap extends StatefulWidget {
  final List<Event> events;
  final EventMapController? controller;

  const EventMap({super.key, required this.events, this.controller});

  @override
  State<StatefulWidget> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap> {
  late GoogleMapController mapController;
  final DateFormat dateFormat = DateFormat('MMM d, yyyy - h:mm a');
  final String mapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bdbdbd"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#181818"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1b1b1b"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#2c2c2c"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8a8a8a"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#373737"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3c3c3c"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#4e4e4e"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#000000"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3d3d3d"
          }
        ]
      }
    ]
    ''';

  Set<Marker> _createMarkers() {
    return widget.events.asMap().entries.map((entry) {
      final Event event = entry.value;

      return Marker(
        markerId: MarkerId(event.name),
        position: LatLng(event.latitude, event.longitude),
        infoWindow: InfoWindow(
          title: event.name,
          snippet: dateFormat.format(event.time),
        ),
        // Use BitmapDescriptor.defaultMarkerWithHue for different marker colors
        icon: BitmapDescriptor.defaultMarkerWithHue(
          event.isUpcoming
              ? BitmapDescriptor
                  .hueAzure // Blue for upcoming
              : BitmapDescriptor.hueOrange, // Orange for past
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    // Center map on average position of all events or default to US center
    LatLng center;
    if (widget.events.isNotEmpty) {
      double avgLat =
          widget.events.map((e) => e.latitude).reduce((a, b) => a + b) /
          widget.events.length;
      double avgLng =
          widget.events.map((e) => e.longitude).reduce((a, b) => a + b) /
          widget.events.length;
      center = LatLng(avgLat, avgLng);
    } else {
      center = const LatLng(37.0902, -95.7129); // Center of US
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GoogleMap(
        style: mapStyle,
        initialCameraPosition: CameraPosition(target: center, zoom: 4),
        markers: _createMarkers(),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;

          // Set the controller in the provided EventMapController if available
          if (widget.controller != null) {
            widget.controller!.setMapController(controller);
          }
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }

  // Method to focus on a specific event
  void focusOnEvent(Event event) {
    final LatLng position = LatLng(event.latitude, event.longitude);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 12.0, // Higher zoom level to focus on the event
        ),
      ),
    );
  }
}
