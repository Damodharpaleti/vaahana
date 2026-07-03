import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  // GoogleMaps({Key key, this.latitude, this.longitude}) : super(key: key);
  // double latitude;
  // double longitude;

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  // @override
  // void initState() {
  //   super.initState();
  //   double d = this.widget.latitude;
  // }

  late GoogleMapController googleMapController;

  //List<MapMarker> mapMarkers = [];
  List<Marker> customMarkers = [];
  // CameraPosition _initialCameraPosition =
  //     CameraPosition(target: LatLng(12.7467, 77.8170));
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(12.7467, 77.8170),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        appBar: AppBar(title: Text("Google Maps")),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController c) {
                // to control the camera position of the map
                googleMapController = c;
              },
            ),
            TextButton(onPressed: () {}, child: Text("Directions"))
          ],
        ),
        bottomNavigationBar:
            TextButton(onPressed: () {}, child: Text("Directions")),
      ),
    );
  }
}
