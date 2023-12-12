import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jom_pick/HomeScreen.dart';
import 'PickUpLocationService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

// void main() => runApp(MyMap());
//
// class MyMap extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Google Maps Demo',
//       home: PickupLocationMap(),
//     );
//   }
// }

class PickupLocationMap extends StatefulWidget {

  final String destinationAddress;

  //const PickupLocationMap({super.key, required this.destinationAddress});

  const PickupLocationMap({Key? key, required this.destinationAddress})
      : super(key: key);

  @override
  State<PickupLocationMap> createState() => PickupLocationMapState();
}

class PickupLocationMapState extends State<PickupLocationMap> {

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  TextEditingController _originLocationController = TextEditingController();
  TextEditingController _destinationLocationController = TextEditingController();

  // location.LocationData? _currentLocation;
  // location.Location locationService = location.Location();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  Set<Polyline> _polylines = Set<Polyline>();

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10,
  );

  @override
  void initState(){
    super.initState();
    //String defaultPlaceId = 'DEFAULT_PLACE_ID';
    _setMarker(LatLng(37.42796133580664, -122.085749655962,), 'YOUR_ACTUAL_PLACE_ID');
    _destinationLocationController.text = widget.destinationAddress;
    _getCurrentLocation();
    _searchLocation();
  }

  // Set marker to searched location
  void _setMarker(LatLng point, String placeId) async{
    setState(() {
      _markers.add(
          Marker(markerId: MarkerId('marker'),
          position: point,
            onTap: () {
            getPlaceDetails(placeId);
            }
         ),
      );
    });
  }

  void _setPolygon(){
    final String polygonIdVal = 'polygon_$_polygonIdCounter';   // Create polygon with different Id
    _polygonIdCounter++;

    _polygons.add(
        Polygon(
            polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
        ),
    );
  }

  void _setPolyline(List<PointLatLng> points){
    final String polylineIdVal = 'polygon_$_polylineIdCounter';   // Create polygon with different Id
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: Colors.red,
        points: points.map(
              (point)=> LatLng(point.latitude, point.longitude),
        ).toList(),
    ),
    );
  }

  // Future<void> _getCurrentLocation() async {
  //     try{
  //       final location.LocationData currentLocation = await locationService.getLocation();
  //       setState(() {
  //         _currentLocation = _currentLocation;
  //         _originLocationController.text = "${_currentLocation!.latitude}, ${_currentLocation!.longitude}";
  //         print("Current location: ${currentLocation.latitude}, ${currentLocation.longitude}");
  //       });
  //     }catch(e){
  //       print('Error retrieve current location: $e');
  //     }
  // }

  Future<void> _getCurrentLocation() async{
    try{
      LocationPermission permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
        print('Location permission denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _originLocationController.text = await _getPlaceName(position.latitude, position.longitude);
      //_originLocationController.text = "${position.latitude}, ${position.longitude}";

      _setMarker(LatLng(position.latitude, position.longitude), 'YOUR_ACTUAL_PLACE_ID');

      // Call for seachLocation method to directly navigate the map to the destinatin from origin
      await _searchLocation();

      print("Current location ${position.latitude}, ${position.longitude} ");

    }catch(e){
      print('Error retrieving current location : $e');
    }
  }

  Future<String> _getPlaceName(double latitude, double longitude) async{
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if(placemarks.isNotEmpty){
      Placemark place = placemarks[0];
      return place.name ?? "Unknown Location";
    }else{
      return "Unkown Location";
    }
  }

  Future<void> _searchLocation() async {
    var directions = await LocationService().getDirections(
      _originLocationController.text,
      _destinationLocationController.text,
    );

    double destinationLat = directions['end_location']['lat'];
    double destinationLng = directions['end_location']['lng'];
    _destinationMarker = _destinationMarker.copyWith(positionParam: LatLng(destinationLat, destinationLng));

    _goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );

    _setPolyline(directions['polyline_decoded']);
  }

  Future<void> getPlaceDetails(String placeId) async{

    final apiKey = 'AIzaSyBgod1ukFHd2DOAwVNedNvKWxCdQoQXvww';
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,photos&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the response and extract the details you need (e.g., photos)
      Map<String, dynamic> data = json.decode(response.body);

      // Extracting name and photos from the response
      String placeName = data['result']['name'];
      List<dynamic> photos = data['result']['photos'];

      // Handle the extracted data as needed, for example:
      print('Place Name: $placeName');

      if (photos != null && photos.isNotEmpty) {
        // Handle photos
        for (dynamic photo in photos) {
          String photoReference = photo['photo_reference'];
          // You can use the photo reference to construct the photo URL
          String photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
          print('Photo URL: $photoUrl');
        }
      } else {
        print('No photos available for this place.');
      }

      // Example: Update UI or perform other actions based on the details
      // handleDetailsResponse(data);
    } else {
      // Handle errors, check response.statusCode and response.body
      print('Failed to fetch place details: ${response.statusCode}');
    }
  }

  // Create marker
  static final Marker _kGooglePlexMarker =
  Marker(markerId : MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'Google Plex'), // View some info when user click on marker
    icon:  BitmapDescriptor.defaultMarker,
    position:  LatLng(37.42796133580664, -122.085749655962),
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Marker _destinationMarker = Marker(
      markerId: MarkerId('destination'),
  infoWindow: InfoWindow(title: 'Destination'),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  position: LatLng(0.0,0.0),
  );

  // Create marker
  static final Marker _kLakeMarker =
  Marker(markerId : MarkerId('_kLakeMarket'),
    infoWindow: InfoWindow(title: 'Lake'), // View some info when user click on marker
    icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position:  LatLng(37.43296265331129, -122.08832357078792),
  );

  static final Polyline _kPolyLine = Polyline(
      polylineId: PolylineId('_kPolyLine'),
  points: [
    LatLng(37.42796133580664, -122.085749655962),
    LatLng(37.43296265331129, -122.08832357078792),
  ],
    width: 5,
  );

  static final Polygon _kPolygon =
  Polygon(polygonId: PolygonId('_kPolygon'),
    points: [
      LatLng(37.43296265331129, -122.08832357078792),
      LatLng(37.42796133580664, -122.085749655962),
      LatLng(37.418, -122.092),
      LatLng(37.435, -122.092),
    ],
    strokeWidth: 5,
    fillColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Up Location'),
      backgroundColor: Colors.blue[900],
      actions: [
        IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> HomeScreen()),
              );
            },
        ),
      ],),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originLocationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Origin'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextFormField(
                      controller: _destinationLocationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Destination'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              // IconButton(
              //   onPressed: () async {
              //     var directions = await LocationService().getDirections(
              //         _originLocationController.text,
              //         _destinationLocationController.text,
              //     );
              //     _goToPlace(
              //         directions['start_location']['lat'],
              //         directions['start_location']['lng'],
              //         directions['bounds_ne'],
              //         directions['bounds_sw'],
              //     );
              //
              //     _setPolyline(directions['polyline_decoded']);
              //   },
              //   icon: Icon(Icons.search),
              // ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {
                ..._markers,
                _destinationMarker,
              },
              polygons: _polygons,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _goToPlace(
      //Map<String, dynamic> place
       double lat,
      double lng,
      Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw,
      ) async {

    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ),
    );

    controller.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
                northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
            ),
        25),
    );
    _setMarker(LatLng(lat, lng), 'YOUR_ACTUAL_PLACE_ID');
  }

}