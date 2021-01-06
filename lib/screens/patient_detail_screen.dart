import 'dart:io';

import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/chat_screen.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class PatientDetailScreen extends StatefulWidget {
  PatientDetailScreen({this.profileImage, this.patient, this.currentUser, this.fromMessageScreen = false});
  File profileImage;
  Patient patient;
  Doctor currentUser;
  bool fromMessageScreen;
  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  @override
  void initState() {
    if (widget.profileImage == null) {
      getProfileImage(widget.patient.patientID);
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

  List<Widget> diseasesView(BuildContext context) {
    List<Widget> diseases = [];
    for (String disease in widget.patient.patientDiseaseList) {
      diseases.add(
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
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: kmainHeadingColor1.withAlpha(150), width: 0.5),
                ),
                child: Text(
                  disease,
                  style: TextStyle(color: kmainHeadingColor1, fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return diseases;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                        height: 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.patient.patientName,
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
                                'Age: ${widget.patient.patientAge} years',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text('From ${widget.patient.patientCity}, ${widget.patient.patientCountry}.',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kdarkTextColor.withAlpha(180))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  child: Text(widget.patient.patientDiseaseList.length > 1 ? 'Medical Conditions' : 'Medical Condition',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: widget.patient.patientDiseaseList.length != 0
                      ? Wrap(
                          alignment: WrapAlignment.center,
                          children: diseasesView(context),
                        )
                      : SizedBox(
                          height: 100,
                          child: Text(
                            'This user have not addded any Medical Conditions to their profile.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: kdarkTextColor.withAlpha(180),
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 35, bottom: 20),
              alignment: Alignment.center,
              child: Visibility(
                visible: !widget.fromMessageScreen,
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
                                receiver: widget.patient,
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
            ),
          ],
        ),
      ),
    );
  }
}
