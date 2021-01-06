import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/login_sing_up_screen.dart';
import 'package:patient_assistant_app/screens/messages_screen.dart';
import 'package:patient_assistant_app/screens/my_doctors_screen.dart';
import 'package:patient_assistant_app/screens/my_patients_screen.dart';
import 'package:patient_assistant_app/screens/my_profile_screen.dart';
import 'package:patient_assistant_app/screens/parmacy_locator_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreenDrawer extends StatelessWidget {
  HomeScreenDrawer({this.user, this.profileImage});
  final dynamic user;
  final File profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.only(left: 15, right: 5),
            decoration: BoxDecoration(
                color: Colors.black38,
                gradient: LinearGradient(
                  colors: [Colors.lightGreen.withAlpha(190), Color(0xff329D9C).withAlpha(190)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 20, bottom: 15),
                  height: 80,
                  width: 80,
                  child: profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: FileImage(profileImage),
                            fadeInCurve: Curves.easeInExpo,
                            fadeInDuration: Duration(milliseconds: 500),
                          ))
                      : Icon(
                          Icons.account_circle,
                          size: 38,
                          color: kmainHeadingColor1,
                        ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 3),
                        blurRadius: 3,
                      )
                    ],
                  ),
                ),
                Text(
                  user.runtimeType == Patient ? user.patientName : user.doctorName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 23, color: kmainHeadingColor1, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 5),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'email',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: kdarkTextColor),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, bottom: 30),
            height: MediaQuery.of(context).size.height * 0.58,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MyProfileScreen(user: user, profileImage: profileImage)));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/user_profile_3.svg',
                          color: kmainHeadingColor1.withAlpha(200),
                          height: 25,
                          width: 25,
                        ),
                        Container(
                            height: 60,
                            margin: EdgeInsets.only(right: 35, left: 18),
                            child: Center(
                                child: Text('My Profile',
                                    style:
                                        TextStyle(color: kmainHeadingColor1, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'Montserrat')))),
                      ],
                    )),
                user.runtimeType == Patient
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MyDoctorsScreen(user: user)));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/healthcare-medical-healthcare.svg',
                              color: kmainHeadingColor1.withAlpha(200),
                              height: 25,
                              width: 25,
                            ),
                            Container(
                                height: 60,
                                margin: EdgeInsets.only(right: 28, left: 18),
                                child: Center(
                                    child: Text('My Doctors',
                                        style: TextStyle(
                                            color: kmainHeadingColor1, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'Montserrat')))),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MyPatientsScreen(user: user)));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/user_profile_2.svg',
                              color: kmainHeadingColor1,
                              height: 29,
                              width: 29,
                            ),
                            Container(
                                height: 60,
                                margin: EdgeInsets.only(right: 30, left: 18),
                                child: Center(
                                    child: Text('My Patients',
                                        style: TextStyle(
                                            color: kmainHeadingColor1, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'Montserrat')))),
                          ],
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MessagesScreen(user: user)));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/chat1.svg',
                        color: kmainHeadingColor1,
                        height: 30,
                        width: 30,
                      ),
                      Container(
                          height: 60,
                          margin: EdgeInsets.only(right: 50, left: 18),
                          child: Center(
                              child: Text('Messages',
                                  style: TextStyle(color: kmainHeadingColor1, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'Montserrat')))),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PharmacyLocatorScreen()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/hospital.svg',
                        color: kmainHeadingColor1,
                        height: 30,
                        width: 30,
                      ),
                      Container(
                          margin: EdgeInsets.only(right: 41, left: 17),
                          height: 60,
                          child: Center(
                              child: Text('Pharmacies',
                                  style: TextStyle(color: kmainHeadingColor1, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'Montserrat')))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(
                  height: 0,
                  indent: 25,
                  endIndent: 25,
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences _prefs = await SharedPreferences.getInstance();
                    await _prefs.setString('signed_in_user_id', null);
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => LoginSignUpScreen()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: (22 / 7) / 12 * 180,
                        child: SvgPicture.asset(
                          'assets/images/logout.svg',
                          color: kerrorColor,
                          height: 25,
                          width: 25,
                        ),
                      ),
                      Container(
                          height: 20,
                          margin: EdgeInsets.only(right: 40, left: 20),
                          child: Center(
                              child: Text('Log Out',
                                  style: TextStyle(
                                    color: kerrorColor,
                                    fontSize: 22,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  )))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
