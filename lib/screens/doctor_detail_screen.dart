import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/chat_screen.dart';
import 'package:patient_assistant_app/screens/workplace_directions_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:transparent_image/transparent_image.dart';

class DoctorDetailScreen extends StatefulWidget {
  DoctorDetailScreen({this.doctor, this.profileImage, this.currentUser, this.fromMessageScreen = false});
  final Doctor doctor;
  File profileImage;
  dynamic currentUser;
  bool fromMessageScreen;

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool isVisible;

  @override
  void initState() {
    if (widget.currentUser.runtimeType == Patient) {
      if (widget.currentUser.patientsDoctorList != null) {
        isVisible = widget.currentUser.runtimeType == Patient && !widget.currentUser.patientsDoctorList.contains(widget.doctor.doctorID);
      } else
        isVisible = true;
    } else
      isVisible = false;
    if (widget.profileImage == null) {
      getProfileImage(widget.doctor.doctorID);
    }
    super.initState();
  }

  getProfileImage(String userID) async {
    File temp = await FirebaseStorageHelper().getLocalProfileImage(userID: userID);
    if (temp == null) {
      temp = await FirebaseStorageHelper().downloadProfileImage(userID: userID);
    }
    precacheImage(FileImage(temp), context);
    setState(() {
      widget.profileImage = temp;
    });
  }

  Widget specialityDescription(String speciality) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: EdgeInsets.all(0),
      content: Builder(
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 15, right: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kappColor1,
                        boxShadow: [
                          BoxShadow(
                            color: kmainHeadingColor1.withAlpha(70),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ],
                        gradient: LinearGradient(
                          colors: [Color(0xa011998e), Color(0xff38ef7d)],
                          begin: Alignment.bottomRight,
                          end: Alignment.centerLeft,
                        ),
                      ),
                      child: Text(speciality,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )),
                    ),
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                          color: kappColor1.withAlpha(200),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(PracticeData.practiceDescription[speciality],
                      style: TextStyle(fontSize: 17, height: 1.5, fontFamily: 'Montserrat', color: kdarkTextColor, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> specialitiesView(BuildContext context) {
    List<Widget> specialities = [];
    for (String speciality in widget.doctor.doctorSpecialtyList) {
      specialities.add(
        Padding(
          padding: EdgeInsets.all(3),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(30),
              splashColor: kmainHeadingColor1,
              highlightColor: Colors.white,
              onTap: () {
                showDialog(context: context, child: specialityDescription(speciality));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: kmainHeadingColor1.withAlpha(150), width: 0.5),
                ),
                child: Text(
                  speciality,
                  style: TextStyle(color: kmainHeadingColor1, fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return specialities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.33,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      gradient: LinearGradient(
                        colors: [Colors.lightGreen.withAlpha(190), Color(0xff329D9C).withAlpha(190)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, top: MediaQuery.of(context).viewPadding.vertical + 15),
                            height: 25,
                            width: 25,
                            child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 15),
                            child: widget.profileImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage(
                                      placeholder: MemoryImage(kTransparentImage),
                                      image: FileImage(widget.profileImage),
                                      fadeInDuration: Duration(milliseconds: 500),
                                    ),
                                  )
                                : SvgPicture.asset('assets/images/user_profile_9.svg', height: 55, width: 55, color: kheadingColor2.withAlpha(100)),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 5, spreadRadius: 1)]),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 25, bottom: 10),
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.doctor.doctorName,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kmainHeadingColor1,
                                    fontSize: 27,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: kSelectedFormDecoration.copyWith(color: Colors.white60),
                                  child: Text(
                                    'Over ${widget.doctor.doctorsExperience} years of Experience',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 35, bottom: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                    color: kappColor1,
                    boxShadow: [
                      BoxShadow(
                        color: kmainHeadingColor1.withAlpha(50),
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ],
                    gradient: LinearGradient(
                      colors: [Color(0xa011998e), Color(0xff38ef7d)],
                      begin: Alignment.bottomRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  child: Text(widget.doctor.doctorSpecialtyList.length > 1 ? 'Specialities' : widget.doctor.doctorSpecialtyList[0],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: widget.doctor.doctorSpecialtyList.length > 1
                      ? Wrap(
                          alignment: WrapAlignment.center,
                          children: specialitiesView(context),
                        )
                      : Text(PracticeData.practiceDescription[widget.doctor.doctorSpecialtyList[0]],
                          style: TextStyle(fontSize: 17, height: 1.5, fontFamily: 'Montserrat', color: kdarkTextColor, fontWeight: FontWeight.w400)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                    color: kappColor1,
                    boxShadow: [
                      BoxShadow(
                        color: kmainHeadingColor1.withAlpha(50),
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.centerLeft,
                      colors: [Color(0xa011998e), Color(0xff38ef7d)],
                    ),
                  ),
                  child: Text('Workplace',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/location1.svg', color: kmainHeadingColor1, height: 45),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  widget.doctor.doctorsWorkplaceName,
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Montserrat', color: kmainHeadingColor1.withAlpha(220), fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${widget.doctor.doctorsWorkplaceAddress}, ${widget.doctor.doctorCity}, ${widget.doctor.doctorCountry}',
                                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: InkWell(
                          splashFactory: InkRipple.splashFactory,
                          borderRadius: BorderRadius.circular(30),
                          splashColor: kappColor1,
                          highlightColor: Colors.white,
                          onTap: () {
                            if (widget.doctor != null) {
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => WorkplaceDirectionsScreen(doctor: widget.doctor)));
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 75,
                            child: Center(
                                child: Text(
                              'Directions',
                              style: TextStyle(color: kappColor1, fontWeight: FontWeight.bold),
                            )),
                            decoration: BoxDecoration(
                              border: Border.all(color: kappColor1.withAlpha(200)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        'Appointment fee',
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                      ),
                      SizedBox(width: 10),
                      Text(widget.doctor.doctorsAppointmentFee, style: TextStyle(fontSize: 20, color: kappColor1, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        'Phone No:',
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                      ),
                      SizedBox(width: 10),
                      Text(widget.doctor.doctorPhoneNo, style: TextStyle(fontSize: 20, color: kappColor1, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.1,
                  endIndent: MediaQuery.of(context).size.width * 0.1,
                ),
                SizedBox(height: 20),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: isVisible && !widget.fromMessageScreen ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: isVisible,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(30),
                        splashColor: kappColor1,
                        highlightColor: Colors.white,
                        onTap: () async {
                          bool isInternetAvailable = await DataConnectionChecker().hasConnection;
                          if (!isInternetAvailable) {
                            widget.currentUser.patientsDoctorList.add(widget.doctor.doctorID);
                            await DBHelper().insertPatientDB(widget.currentUser);
                            await DBHelper().insertDoctorDB(widget.doctor);
                            setState(() {
                              isVisible = false;
                            });
                          } else {
                            widget.currentUser.patientsDoctorList.add(widget.doctor.doctorID);
                            await DBHelper().insertPatientDB(widget.currentUser);
                            await DBHelper().insertDoctorDB(widget.doctor);
                            await FirestoreHandler().savePatientFirestore(widget.currentUser);
                            setState(() {
                              isVisible = false;
                            });
                          }
                          _key.currentState.showSnackBar(SnackBar(
                              backgroundColor: Color(0xff2f9f8f),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 3),
                              content: Row(
                                children: [
                                  Icon(Icons.save, color: Colors.white, size: 25),
                                  SizedBox(width: 25),
                                  Text('Profile Updated', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                                ],
                              )));
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.42,
                          alignment: Alignment.center,
                          child: Text(
                            'Add to My Doctors',
                            style: TextStyle(fontSize: 17, color: kappColor1, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: kappColor1.withAlpha(200), width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !widget.fromMessageScreen && widget.currentUser.runtimeType == Patient,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.white,
                        highlightColor: Colors.white,
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => ChatScreen(
                                    user: widget.currentUser,
                                    receiver: widget.doctor,
                                    receiverImage: widget.profileImage,
                                  )));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.42,
                          alignment: Alignment.center,
                          child: Text(
                            'Message',
                            style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                          ),
                          decoration: kGetStartedButton.copyWith(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
