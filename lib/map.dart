import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'auth.dart';

class map extends StatefulWidget {
  @override
  _mapState createState() => _mapState();

}

class _mapState extends State<map> {

  Set<Marker> allMarkers = {};
  String _mapStyle;
  GoogleMapController mapController;
  LatLng lastMapPosition;
  Location location = new Location();

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  _animateToUser() async {
    var pos = await location.getLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.latitude),
          zoom: 17.0,
        )
    )
    );
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore.collection('locations').add({
      'position': point.data,
      'name': 'Yay I can be queried!'
    });
  }

  void addmarker(){
    setState(() {
      allMarkers.add(
        Marker(
          markerId: MarkerId(lastMapPosition.toString()),
          position: lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }
  onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/map.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff027373),
        elevation: 0.0,
        title: Text('Orb Map', style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        leading: IconTheme(
          data: IconThemeData(

            size: 30.0,
            color: Colors.white,
          ),
          child: GestureDetector(
            onTap: (){
              signOutGoogle();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.transit_enterexit,
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(24.142,-110.321), zoom: 16),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            markers: allMarkers,
            onCameraMove: onCameraMove,
          ),
          Positioned(
            bottom: 110,
            right: 5,
            child: FloatingActionButton(
              backgroundColor: Color(0xff027373),
              child: Icon(
                Icons.pin_drop,
              ),
              onPressed: (){
                _addGeoPoint();
                addmarker();
              },
            ),
          ),

        ],
      ),
    );
  }
  void _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
      mapController.setMapStyle(_mapStyle);
    });
  }
}



