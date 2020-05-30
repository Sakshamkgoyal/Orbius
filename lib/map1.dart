import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart' as a;



class map1 extends StatefulWidget {
  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map1> {

  List<Marker> allMarkers= [];

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  String _mapStyle;
  var Position2;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/arrow.png");
    return byteData.buffer.asUint8List();
  }

  void getLocation() async {
    a.Position position1 = await a.Geolocator().getCurrentPosition(desiredAccuracy: a.LocationAccuracy.high);
    position1 = Position2;
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("arrow"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void addMarker(){
    var marker = Marker(
      position: Position2,
      icon: BitmapDescriptor.defaultMarker,
    );
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('myMarker'),
      draggable: false,
      onTap: (){
        print('Marker Tapped');
      },
      position: LatLng(37.42796133580664, -122.085749655962),
    ));
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
              initialCameraPosition: initialLocation,
              myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
              mapType: MapType.normal,
              compassEnabled: true,
            markers: Set.from(allMarkers),
            circles: Set.of((circle != null) ? [circle] : []),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller.setMapStyle(_mapStyle);
            },
          ),
          Positioned(
            bottom: 110,
            right: 5,
            child: FloatingActionButton(
              backgroundColor: Color(0xff027373),
              child: Icon(
                Icons.location_searching,
              ),
              onPressed: (){
                getCurrentLocation();
              },
            ),
          ),
          Positioned(
            bottom: 175,
            right: 5,
            child: FloatingActionButton(
              backgroundColor: Color(0xff027373),
              child: Icon(
                Icons.pin_drop,
              ),
              onPressed: (){
                addMarker;
              },
            ),
          ),
        ],
      ),
    );
  }
}




