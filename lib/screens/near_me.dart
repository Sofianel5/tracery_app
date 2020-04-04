import 'dart:async';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracery_app/models/venue_model.dart';

class NearMeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NearMeScreenState();
}

class NearMeScreenState extends State<NearMeScreen> {
  UserRepository userRepo;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers;

  Future<List<Marker>> getVenueMarkers() async {
    List<Venue> _venues = await userRepo.getVenues();
    List<Marker> markers = [];
    for (var venue in _venues) {
      markers.add(
        Marker(
          markerId: MarkerId(
            venue.id.toString(),
          ),
          position: LatLng(venue.coordinates.lat, venue.coordinates.lng),
          infoWindow: InfoWindow(title: venue.title, snippet: venue.securityValue.toString())
        ),
      );
    }
    print(markers);
    setState(() {
      _markers = markers;
    });
  }

  static final CameraPosition _center = CameraPosition(
    target: LatLng(40.7175553, -74.0107331),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    if (userRepo == null) {
      userRepo = Provider.of<UserRepository>(context);
    }
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _center,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        getVenueMarkers();
      },
      markers: _markers == null ? Set<Marker>() : _markers.toSet()
    );
  }
}
