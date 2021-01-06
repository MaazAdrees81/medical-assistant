import 'dart:io';

import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/screens/doctor_detail_screen.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class RecommendationCard extends StatefulWidget {
  RecommendationCard({this.doctor, this.currentUser});
  Doctor doctor;
  final dynamic currentUser;
  @override
  _RecommendationCardState createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  File profileImage;
  @override
  void initState() {
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
      profileImage = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.16,
            color: Colors.transparent,
          ),
          Container(
            margin: EdgeInsets.only(left: 25),
            padding: EdgeInsets.only(left: 55, top: 10, bottom: 10),
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width * 0.78,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: kmainHeadingColor1.withAlpha(50), blurRadius: 12)],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.43,
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
                      SizedBox(height: 8),
                      Row(
                        children: [
                          LimitedBox(
                            maxWidth: MediaQuery.of(context).size.width * 0.38,
                            child: Container(
                              margin: EdgeInsets.only(right: 4),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: kprimaryColor,
                                gradient: LinearGradient(
                                  colors: [Color(0xa011998e), Color(0xff38ef7d)],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.centerLeft,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.doctor.doctorSpecialtyList[0],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          widget.doctor.doctorSpecialtyList.length > 1
                              ? Text(
                                  '+${widget.doctor.doctorSpecialtyList.length - 1}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: kmainHeadingColor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('${widget.doctor.doctorCity}, ${widget.doctor.doctorCountry}.',
                          overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
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
                          builder: (context) =>
                              DoctorDetailScreen(doctor: widget.doctor, profileImage: profileImage, currentUser: widget.currentUser),
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
          ),
          Container(
            height: 70,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: kmainHeadingColor1.withAlpha(40),
                  offset: Offset(-3, 0),
                  blurRadius: 9,
                )
              ],
            ),
            child: profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: FileImage(profileImage),
                      fadeInDuration: Duration(milliseconds: 500),
                    ),
                  )
                : SvgPicture.asset('assets/images/user_profile_9.svg', height: 55, width: 55, color: kheadingColor2.withAlpha(100)),
          ),
        ],
      ),
    );
  }
}
