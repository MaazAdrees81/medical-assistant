import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/keys.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';

class WorkplaceDirectionsScreen extends StatefulWidget {
  WorkplaceDirectionsScreen({this.doctor});
  final Doctor doctor;
  @override
  _WorkplaceDirectionsScreenState createState() =>
      _WorkplaceDirectionsScreenState();
}

class _WorkplaceDirectionsScreenState extends State<WorkplaceDirectionsScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  StreamSubscription<DataConnectionStatus> connectionStream;
  String get address =>
      '${widget.doctor.doctorsWorkplaceName}, ${widget.doctor.doctorsWorkplaceAddress}, ${widget.doctor.doctorCity}, ${widget.doctor.doctorCountry}';
  bool connection;
  bool myLocationEnabled = false;
  bool isPositionAvailable = false;
  //    Location Service
  LocationPermission permission;
  bool isServiceEnabled;
  //    Map Position and Controller
  Position userPosition;
  Location workplaceLocation;
  StreamSubscription<Position> position;
  Completer<GoogleMapController> _mapController = Completer();
  CameraPosition initialPosition = CameraPosition(target: LatLng(0.0, 0.0));
  CameraPosition userCameraPosition;
  CameraPosition addressCameraPosition;
  //    Places Markers
  List<Marker> marker = <Marker>[];
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
    position.cancel();
    connectionStream.cancel();
    super.dispose();
  }

  Future<void> checkLocationPermissionAndService() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
    } else {
      permission = await Geolocator.requestPermission();
    }
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await showDialog(
          context: _key.currentContext,
          builder: (_) => showAlert(
              desc:
                  'Location service not enabled. Please location to use this feature.'));
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
          builder: (_) => showAlert(
              desc:
                  'Your are not connected to Internet. Please check your connection to use this feature and try again.'));
    }
    connectionStream =
        DataConnectionChecker().onStatusChange.listen((status) async {
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

  markDoctorAddress() async {
    List<Location> location = await locationFromAddress(
        '${widget.doctor.doctorsWorkplaceName}, ${widget.doctor.doctorsWorkplaceAddress}, ${widget.doctor.doctorCity}, ${widget.doctor.doctorCountry}');
    setState(() {
      workplaceLocation = location[0];
      addressCameraPosition = CameraPosition(
          target:
              LatLng(workplaceLocation.latitude, workplaceLocation.longitude),
          tilt: 20,
          zoom: 15);
      marker.add(
        Marker(
          markerId: MarkerId('Doctor Workplace Address'),
          position: LatLng(location[0].latitude, location[0].longitude),
          infoWindow: InfoWindow(
            title: widget.doctor.doctorsWorkplaceName,
            snippet: address,
          ),
        ),
      );
    });
  }

  Future<void> drawDirectionLines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsKey,
        PointLatLng(userPosition.latitude, userPosition.longitude),
        PointLatLng(workplaceLocation.latitude, workplaceLocation.longitude));
    List<LatLng> polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      showDialog(
          context: _key.currentContext,
          builder: (_) => showAlert(
              desc:
                  'The direction for Doctors Workplace were not found. Please try again'));
    }
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('Doctor Workplace Address'),
          width: 5,
          color: kappColor1,
          points: polylineCoordinates);
      directions.clear();
      directions.add(polyline);
    });
  }

  listenUserPositionUpdates() {
    position = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .listen((position) {
      setState(() {
        userPosition = position;
        userCameraPosition = CameraPosition(
            target: LatLng(userPosition.latitude, userPosition.longitude),
            tilt: 20,
            zoom: 15);
      });
    });
  }

  Future<void> moveToUserPosition() async {
    Position userPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (userPos != null) {
      setState(() {
        userPosition = userPos;
        userCameraPosition = CameraPosition(
            target: LatLng(userPosition.latitude, userPosition.longitude),
            tilt: 20,
            zoom: 15);
        isPositionAvailable = true;
        myLocationEnabled = true;
      });
      GoogleMapController controller = await _mapController.future;
      controller.moveCamera(CameraUpdate.newCameraPosition(userCameraPosition));
      await markDoctorAddress();
      await drawDirectionLines();
      listenUserPositionUpdates();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          height: 90,
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.vertical + 5,
              bottom: 5,
              left: 15),
          decoration: BoxDecoration(
            gradient: ksearchScreenGradient,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: Icon(Icons.keyboard_backspace,
                        color: Colors.white, size: 25)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.doctor.doctorName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            height: 1,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        address,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                isPositionAvailable ? userCameraPosition : initialPosition,
            mapType: MapType.normal,
            myLocationEnabled: myLocationEnabled,
            markers: Set.of(marker),
            polylines: Set.of(directions),
            myLocationButtonEnabled: myLocationEnabled,
            onMapCreated: (GoogleMapController controller) async {
              _mapController.complete(controller);
            },
          ),
          Positioned(
            bottom: 20,
            child: Visibility(
              visible: userPosition != null && workplaceLocation != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    replacement: GestureDetector(
                      onTap: () async {
                        if (connection) {
                          await drawDirectionLines();
                        } else {
                          showDialog(
                              context: _key.currentContext,
                              builder: (_) => showAlert(
                                  desc:
                                      'Your are not connected to Internet. Please check your connection to use this feature and try again.'));
                        }
                      },
                      child: Container(
                        width: 85,
                        height: 30,
                        margin: EdgeInsets.only(left: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            'Directions',
                            style: TextStyle(
                                color: kappColor1,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: kappColor1,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
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
                            style: TextStyle(
                                color: Color(0xffdd1818),
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
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
                    onTap: () async {
                      if (addressCameraPosition != null) {
                        GoogleMapController controller =
                            await _mapController.future;
                        controller.moveCamera(CameraUpdate.newCameraPosition(
                            addressCameraPosition));
                      }
                    },
                    child: Container(
                      width: 110,
                      height: 40,
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: Center(
                        child: Text(
                          'Workplace',
                          style: kgetStartedBtn,
                        ),
                      ),
                      decoration: kGetStartedButton.copyWith(
                          borderRadius: BorderRadius.circular(70),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 2),
                          ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (userCameraPosition != null) {
                        GoogleMapController controller =
                            await _mapController.future;
                        controller.moveCamera(
                            CameraUpdate.newCameraPosition(userCameraPosition));
                      }
                    },
                    child: Container(
                      width: 110,
                      height: 40,
                      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Center(
                        child: Text(
                          'My Position',
                          style: kgetStartedBtn,
                        ),
                      ),
                      decoration: kGetStartedButton.copyWith(
                          borderRadius: BorderRadius.circular(70),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 2),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
