import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const double YOUR_DESTINATION_LAT = 37.7749; // Example latitude (e.g., San Francisco)
const double YOUR_DESTINATION_LNG = -122.4194; // Example longitude
const String GOOGLE_MAPS_API_KEY = 'AIzaSyDqUr9fg0_ClrzjYqguriPtrO53PJoSRlo"'; // Replace with your API key

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

          // Calculate and display directions
          String directions = await getDirections(
              userLatLng,
              LatLng(YOUR_DESTINATION_LAT, YOUR_DESTINATION_LNG),
              GOOGLE_MAPS_API_KEY);

          // Display the directions or handle them as needed
          // For now, let's print the directions
          print(directions);
        },
        child: Icon(Icons.directions_walk),
      ),
    );
  }

  Future<String> getDirections(
      LatLng origin, LatLng destination, String apiKey) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
            'origin=${origin.latitude},${origin.longitude}&'
            'destination=${destination.latitude},${destination.longitude}&'
            'key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return 'Directions: ${data["routes"][0]["legs"][0]["steps"][0]["html_instructions"]}';
      // You can extract and format the directions as needed from the response.
    } else {
      throw Exception('Failed to load directions');
    }
  }
}