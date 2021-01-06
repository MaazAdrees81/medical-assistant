import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/doctor_detail_screen.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class SearchCard extends StatefulWidget {
  SearchCard({this.doctor, this.keyword, this.user, this.inUserCountryOnly});
  final Doctor doctor;
  final List<String> keyword;
  dynamic user;
  final bool inUserCountryOnly;
  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  File _profileImage;

  @override
  initState() {
    getProfileImage(context: Scaffold.of(context).context, userID: widget.doctor.doctorID);
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

  Widget showFeaturesDialog({BuildContext context, String title, List<String> featureList}) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.all(0),
      content: Builder(builder: (context) {
        List<Widget> featureContainers = [];
        for (String feature in featureList) {
          featureContainers.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff57D583), Color(0xff46A98C)], //Color(0xb838ef7d)
                    end: Alignment.centerRight,
                    begin: Alignment.topLeft),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      feature,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5, top: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                          color: kappColor1,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 22, color: Color(0xff57D583), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'This Specialist was found based on the following keywords',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: featureContainers,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.doctorName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: kmainHeadingColor1,
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Appointment fee',
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                    ),
                    SizedBox(width: 5),
                    Text(widget.doctor.doctorsAppointmentFee, style: TextStyle(fontSize: 18, color: kappColor1, fontWeight: FontWeight.w500)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.keyword.length > 1) {
                      showDialog(context: context, child: showFeaturesDialog(context: context, title: 'Result For:', featureList: widget.keyword));
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('Result for:', style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.40),
                        child: Text(
                          widget.keyword.length > 0
                              ? widget.keyword[0]
                              : widget.inUserCountryOnly
                                  ? '${widget.user.runtimeType == Patient ? widget.user.patientCountry : widget.user.doctorCountry} only'
                                  : 'All Countries',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: kprimaryColor,
                          gradient: LinearGradient(
                            colors: [Color(0xa011998e), Color(0xff38ef7d)],
                            begin: Alignment.bottomRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      widget.keyword.length > 1
                          ? SizedBox(
                              height: 30,
                              width: 25,
                              child: Center(
                                child: Text(
                                  '+${widget.keyword.length - 1}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: kmainHeadingColor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
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
                    builder: (context) => DoctorDetailScreen(doctor: widget.doctor, profileImage: _profileImage, currentUser: widget.user),
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
