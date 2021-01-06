import 'dart:io';

import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/patient_detail_screen.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:transparent_image/transparent_image.dart';

class PatientCard extends StatefulWidget {
  PatientCard({this.user, this.patient});
  final dynamic user;
  final Patient patient;

  @override
  _PatientCardState createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  File _profileImage;

  @override
  initState() {
    getProfileImage(context: Scaffold.of(context).context, userID: widget.patient.patientID);
    super.initState();
  }

  getProfileImage({BuildContext context, String userID}) async {
    File temp = await FirebaseStorageHelper().getLocalProfileImage(userID: userID);
    if (temp == null) {
      temp = await FirebaseStorageHelper().downloadProfileImage(userID: userID);
    }
    precacheImage(FileImage(temp), context);
    setState(() {
      _profileImage = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: kmainHeadingColor1.withAlpha(40), blurRadius: 8)],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 75,
            width: 75,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                )
              ],
            ),
            child: _profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: FileImage(_profileImage),
                      fadeInDuration: Duration(milliseconds: 500),
                    ),
                  )
                : SvgPicture.asset('assets/images/user_profile_9.svg', height: 55, width: 55, color: kheadingColor2.withAlpha(100)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.patient.patientName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kmainHeadingColor1,
                      fontFamily: 'Montserrat',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Patient age:',
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                      ),
                      SizedBox(width: 5),
                      Text(widget.patient.patientAge + ' years', style: TextStyle(fontSize: 18, color: kappColor1, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('${widget.patient.patientCity}, ${widget.patient.patientCountry}',
                      overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
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
              highlightColor: kappColor1,
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => PatientDetailScreen(patient: widget.patient, profileImage: _profileImage, currentUser: widget.user),
                  ),
                );
              },
              child: Container(
                height: 30,
                width: 60,
                child: Center(
                    child: Text(
                  'Details',
                  style: TextStyle(color: kappColor1, fontSize: 14, fontWeight: FontWeight.bold),
                )),
                decoration: BoxDecoration(
                  border: Border.all(color: kappColor1.withAlpha(200), width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
