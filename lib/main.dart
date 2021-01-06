import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/screens/home_screen.dart';
import 'package:patient_assistant_app/screens/login_sing_up_screen.dart';
import 'package:patient_assistant_app/screens/welcome_carousel.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _isFirstRun = prefs.getBool("is_first_run") == null ? true : false;
  await prefs.setBool("is_first_run", false);
  String signedInUserID = prefs.getString('signed_in_user_id');
  await DBHelper().openDB();

  List svgList = [
    'assets/images/app_logo.svg',
    'assets/images/1_hi_there(1).svg',
    'assets/images/2_doctors_(1).svg',
    'assets/images/4_user_interface(1).svg',
    'assets/images/5_cloud_sync(3).svg',
    'assets/images/6_pharmacies(1).svg',
    'assets/images/7_drugs_info.svg',
    'assets/images/messaging (1).svg',
    'assets/images/user_profile_9.svg',
    'assets/images/user_group.svg',
    'assets/images/empty_inbox.svg',
    'assets/images/coughing_.svg',
    'assets/images/pills(2).svg',
    'assets/images/not_found.svg',
  ];

  for (String i in svgList) {
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, i), null);
  }

  Future<dynamic> getUserFromID() async {
    if (signedInUserID != null && signedInUserID != '') {
      dynamic userData = await DBHelper().checkIDForUserDatabase(signedInUserID);
      return userData;
    }
  }

  runApp(MyApp(_isFirstRun, await getUserFromID()));
}

class MyApp extends StatelessWidget {
  final bool _isFirstRun;
  final dynamic user;
  MyApp(this._isFirstRun, this.user);

  Widget _screen(BuildContext context) {
    if (_isFirstRun == true) {
      return WelcomeCarousel();
    } else if (_isFirstRun == false && user != null) {
      return HomeScreen(user: user);
    } else if (_isFirstRun == false && user == null) {
      return LoginSignUpScreen();
    } else
      return WelcomeCarousel();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Assistant',
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        primaryColor: kappColor1,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _screen(context),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8), child: child);
      },
    );
  }
}
