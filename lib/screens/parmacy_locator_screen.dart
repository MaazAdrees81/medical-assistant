import 'dart:async';
import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/keys.dart';
import 'package:patient_assistant_app/models/place_response.dart';
import 'package:patient_assistant_app/models/result.dart';

class PharmacyLocatorScreen extends StatefulWidget {
  @override
  _PharmacyLocatorScreenState createState() => _PharmacyLocatorScreenState();
}

class _PharmacyLocatorScreenState extends State<PharmacyLocatorScreen> {
  static const String baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
  // util variables
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String resultFor = 'None';
  StreamSubscription<DataConnectionStatus> connectionStream;
  bool connection;
  bool myLocationEnabled = false;
  bool isSearching = false;
  bool isPositionAvailable = false;
  //    Location Service
  LocationPermission permission;
  bool isServiceEnabled;
  //    Map Position and Controller
  Position userPosition;
  Completer<GoogleMapController> _mapController = Completer();
  CameraPosition initialPosition = CameraPosition(target: LatLng(0.0, 0.0));
  CameraPosition userCameraPosition;
  //    Places Markers
  List<Marker> markers = <Marker>[];
  List<Result> places = <Result>[];
  //    PolyLines (Direction)
  List<Polyline> directions = <Polyline>[];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    connectionChangeListener();
    super.initState();
  }

  @override
  void dispose() {
    connectionStream.cancel();
    super.dispose();
  }

  Future<void> checkLocationPermissionAndService() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    } else {
      permission = await Geolocator.requestPermission();
    }
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await showDialog(
          context: _key.currentContext, builder: (_) => showAlert(desc: 'Location service not enabled. Please location to use this feature.'));
      isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    }
  }

  void connectionChangeListener() async {
    bool temp = await DataConnectionChecker().hasConnection;
    setState(() {
      connection = temp;
    });
    if (connection) {
      await checkLocationPermissionAndService();
      await moveToUserPosition();
    } else {
      showDialog(
          context: _key.currentContext,
          builder: (_) => showAlert(desc: 'Your are not connected to Internet. Please check your connection to use this feature and try again.'));
    }
    connectionStream = DataConnectionChecker().onStatusChange.listen((status) async {
      if (status == DataConnectionStatus.connected) {
        setState(() {
          connection = true;
        });
        if (userPosition == null) {
          await checkLocationPermissionAndService();
          await moveToUserPosition();
        }
      } else {
        setState(() {
          connection = false;
        });
      }
    });
  }

  Widget directionsBottomSheet({BuildContext context, String placeName, String address, dynamic places, int index}) {
    Marker marker = markers[index];
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            marker.infoWindow.title,
            style: TextStyle(
              color: kappColor1,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 20),
          Text(
            marker.infoWindow.snippet,
            style: kalertDescriptionStyle,
          ),
          Expanded(child: SizedBox()),
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(50),
              splashColor: kappColor1,
              highlightColor: kappColor1,
              onTap: () async {
                PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(googleMapsKey,
                    PointLatLng(userPosition.latitude, userPosition.longitude), PointLatLng(marker.position.latitude, marker.position.longitude));
                List<LatLng> polylineCoordinates = [];
                if (result.points.isNotEmpty) {
                  result.points.forEach((PointLatLng point) {
                    polylineCoordinates.add(LatLng(point.latitude, point.longitude));
                  });
                }
                setState(() {
                  Polyline polyline =
                      Polyline(polylineId: PolylineId(marker.markerId.value), width: 5, color: kappColor1, points: polylineCoordinates);
                  directions.clear();
                  directions.add(polyline);
                });
                Navigator.of(context).pop();
              },
              child: Container(
                height: 45,
                width: 120,
                alignment: Alignment.center,
                child: Text(
                  'Directions',
                  style: TextStyle(color: kappColor1, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: kappColor1.withAlpha(200), width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget showAlert({String desc}) {
    return AlertDialog(
      title: Text('Alert !', style: kdialogTitleStyle),
      content: Text(desc, style: kalertDescriptionStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: <Widget>[
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 48, height: 48),
            decoration: kAlertBtnDecoration,
            child: Center(
              child: Text(
                'ok',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Future<void> moveToUserPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (position != null) {
      setState(() {
        markers.clear();
        userPosition = position;
        isSearching = true;
        userCameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), tilt: 20, zoom: 15);
        isPositionAvailable = true;
        myLocationEnabled = true;
      });
      GoogleMapController controller = await _mapController.future;
      controller.moveCamera(CameraUpdate.newCameraPosition(userCameraPosition));
      searchNearby(latitude: userPosition.latitude, longitude: userPosition.longitude, keyword: 'Pharmacy');
      searchNearby(latitude: userPosition.latitude, longitude: userPosition.longitude, keyword: 'Medical Store');
      setState(() {
        resultFor = 'Pharmacies';
        isSearching = false;
      });
    }
  }

  void searchNearby({double latitude, double longitude, String keyword}) async {
    String url = '$baseUrl?key=$googleMapsKey&location=$latitude,$longitude&radius=10000&keyword=$keyword';
    final response = await get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _handlePlacesResponse(data);
    } else {
      showDialog(
          context: _key.currentContext, builder: (_) => showAlert(desc: 'An Error occurred while requesting Nearby Places data. Please try again.'));
    }
  }

  void _handlePlacesResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff2f9f8f),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 25),
              SizedBox(width: 10),
              Text('Request Denied for this Operation.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          )));
    } else if (data['status'] == "OK") {
      int markersLength;
      setState(() {
        markersLength = markers.length;
        places = PlaceResponse.parseResults(data['results']);
        for (int i = 0; i < places.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId(places[i].placeId),
              position: LatLng(places[i].geometry.location.lat, places[i].geometry.location.long),
              infoWindow: InfoWindow(
                title: places[i].name,
                snippet: places[i].vicinity,
              ),
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: _key.currentContext,
                    builder: (context) => directionsBottomSheet(
                          context: context,
                          index: markersLength == 0 ? i : i + markersLength,
                        ));
              },
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          height: 90,
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 5, left: 15),
          decoration: BoxDecoration(
            gradient: ksearchScreenGradient,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SizedBox(height: 25, width: 25, child: Icon(Icons.keyboard_backspace, color: Colors.white, size: 25)),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                margin: EdgeInsets.only(bottom: 5, left: 15),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Currently showing result for ',
                    overflow: TextOverflow.ellipsis,
                    style: kdescriptionStyle,
                  ),
                  Text(
                    resultFor,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: kappColor1, fontSize: 16),
                  )
                ]),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: isPositionAvailable ? userCameraPosition : initialPosition,
            mapType: MapType.normal,
            markers: Set.of(markers),
            polylines: Set.of(directions),
            myLocationEnabled: myLocationEnabled,
            myLocationButtonEnabled: myLocationEnabled,
            scrollGesturesEnabled: !isSearching,
            onMapCreated: (GoogleMapController controller) async {
              _mapController.complete(controller);
            },
          ),
          Positioned(
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: directions.length != 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        directions.clear();
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 30,
                      margin: EdgeInsets.only(left: 15, bottom: 15),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xffdd1818), fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xffdd1818),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (connection) {
                      if (userPosition != null) {
                        setState(() {
                          directions.clear();
                          markers.clear();
                          isSearching = true;
                        });
                        searchNearby(latitude: userPosition.latitude, longitude: userPosition.longitude, keyword: 'Pharmacy');
                        searchNearby(latitude: userPosition.latitude, longitude: userPosition.longitude, keyword: 'Medical Store');
                        setState(() {
                          resultFor = 'Pharmacies';
                          isSearching = false;
                        });
                      }
                    } else {
                      showDialog(
                          context: _key.currentContext,
                          builder: (_) =>
                              showAlert(desc: 'Your are not connected to Internet. Please check your connection to use this feature and try again.'));
                    }
                  },
                  child: Container(
                    width: 110,
                    height: 40,
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: Center(
                      child: Text(
                        'Pharmacies',
                        style: kgetStartedBtn,
                      ),
                    ),
                    decoration: kGetStartedButton.copyWith(borderRadius: BorderRadius.circular(70), boxShadow: [
                      BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 2),
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (connection) {
                      if (userPosition != null) {
                        setState(() {
                          directions.clear();
                          markers.clear();
                          isSearching = true;
                        });
                        searchNearby(latitude: userPosition.latitude, longitude: userPosition.longitude, keyword: 'Hospital');
                        setState(() {
                          resultFor = 'Hospitals';
                          isSearching = false;
                        });
                      }
                    } else {
                      showDialog(
                          context: _key.currentContext,
                          builder: (_) =>
                              showAlert(desc: 'Your are not connected to Internet. Please check your connection to use this feature and try again.'));
                    }
                  },
                  child: Container(
                    width: 110,
                    height: 40,
                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        'Hospitals',
                        style: kgetStartedBtn,
                      ),
                    ),
                    decoration: kGetStartedButton.copyWith(borderRadius: BorderRadius.circular(70), boxShadow: [
                      BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 2),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isSearching,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
