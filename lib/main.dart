import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const double YOUR_DESTINATION_LAT = 37.7749; // Example latitude (e.g., San Francisco)
const double YOUR_DESTINATION_LNG = -122.4194; // Example longitude

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController; // Use a nullable type
  Completer<GoogleMapController> _controllerCompleter = Completer();

  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Map'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controllerCompleter.complete(controller);
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(YOUR_DESTINATION_LAT, YOUR_DESTINATION_LNG),
          zoom: 15.0,
        ),
        markers: Set<Marker>.from([
          Marker(
            markerId: MarkerId('library'),
            position: LatLng(YOUR_DESTINATION_LAT, YOUR_DESTINATION_LNG),
            infoWindow: InfoWindow(title: 'Library'),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var currentLocation = await location.getLocation();
          LatLng userLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
          // Add code to get directions to destinationLatLng from userLatLng
          // You can use a routing service like Google Directions API for this purpose.
        },
        child: Icon(Icons.directions_walk),
      ),
    );
  }
}
