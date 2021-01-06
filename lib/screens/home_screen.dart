import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/disease_info_screen.dart';
import 'package:patient_assistant_app/screens/drug_info_screen.dart';
import 'package:patient_assistant_app/screens/messages_screen.dart';
import 'package:patient_assistant_app/screens/my_doctors_screen.dart';
import 'package:patient_assistant_app/screens/my_patients_screen.dart';
import 'package:patient_assistant_app/screens/my_profile_screen.dart';
import 'package:patient_assistant_app/screens/parmacy_locator_screen.dart';
import 'package:patient_assistant_app/screens/search_specialist_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/add_alarms_row.dart';
import 'package:patient_assistant_app/widgets/feature_container.dart';
import 'package:patient_assistant_app/widgets/home_screen_drawer.dart';
import 'package:patient_assistant_app/widgets/recommendation_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({@required this.user});
  dynamic user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  dynamic get type => widget.user.runtimeType;
  StreamSubscription<DataConnectionStatus> listener;
  String get userID => type == Patient ? widget.user.patientID : widget.user.doctorID;
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
  final DBHelper _dbHelper = DBHelper();
  File _profileImage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String quote, author;
  AnimationController _animController;

  @override
  void initState() {
    loadProfileImage(userID);
    _checkDataConnection();
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    getQuote();
    super.initState();
  }

  @override
  void dispose() {
    listener?.cancel();
    _animController.dispose();
    super.dispose();
  }

  getQuote() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      Response res = await get('https://zenquotes.io/api/today');
      _animController.forward();
      setState(() {
        quote = jsonDecode(res.body)[0]['q'];
        author = jsonDecode(res.body)[0]['a'];
      });
      await _prefs.setString('quote', quote);
      await _prefs.setString('author', author);
    } catch (e) {
      _animController.forward();
      setState(() {
        quote = _prefs.get('quote');
        author = _prefs.get('author');
      });
    }
  }

  String getWelcomeText() {
    int hour = DateTime.now().hour;
    String t;
    if (hour >= 6 && hour <= 12) {
      t = 'Good morning,';
    } else if (hour >= 13 && hour <= 18) {
      t = 'Good afternoon,';
    } else if (hour >= 19 && hour <= 23) {
      t = 'Good evening,';
    } else if (hour >= 0 && hour <= 5) {
      t = 'Good evening,';
    }
    return t;
  }

  String getUserName() {
    List<String> myList;
    String name;
    if (type == Patient) {
      myList = widget.user.patientName.split(" ");
      if (myList.length == 1) {
        name = myList[0];
      } else if (myList.length == 2) {
        name = myList[0];
      } else if (myList.length > 2) {
        name = myList[0] + ' ' + myList[1];
      }
    } else if (type == Doctor) {
      myList = widget.user.doctorName.split(" ");
      if (myList.length == 1) {
        name = myList[0];
      } else if (myList.length == 2) {
        if (myList[0].toLowerCase().startsWith('dr'))
          name = myList[1];
        else
          name = myList[0];
      } else if (myList.length > 2) {
        name = myList[0] + ' ' + myList[1];
      }
    }
    return name;
  }

  _checkDataConnection() async {
    bool con = await DataConnectionChecker().hasConnection;
    if (con) {
      updateDataFirestore();
    }
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      if (status == DataConnectionStatus.connected && mounted) {
        updateDataFirestore();
      }
    });
  }

  updateDataFirestore() async {
    dynamic result = await _firestoreHandler.checkIdForUserFirestore(user: widget.user);
    dynamic user = await _dbHelper.checkIDForUserDatabase(userID);
    if (result != null) {
      if (!MapEquality().equals(result.toMap(), user.toMap())) {
        await _firestoreHandler.pushDataToFirestore(user);
      }
    } else if (result == null) {
      await _firestoreHandler.pushDataToFirestore(user);
    }
  }

  loadProfileImage(String userID) async {
    File temp = await FirebaseStorageHelper().getLocalProfileImage(userID: userID);
    precacheImage(FileImage(temp), context);
    setState(() {
      _profileImage = temp;
    });
  }

  Widget showAlert({String alertMessage, BuildContext context}) {
    return AlertDialog(
      title: Text('Warning', style: kdialogTitleStyle),
      content: Text(alertMessage, style: kalertDescriptionStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: <Widget>[
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 80, height: 40),
            decoration: BoxDecoration(
              color: Color(0xffdd1818).withAlpha(150),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 80, height: 40),
            decoration: BoxDecoration(
              color: kappColor1.withAlpha(200),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'No',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onTap: () async {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(context: context, child: showAlert(alertMessage: 'Are you sure you want to exit Medical Assistant.', context: context));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: SizedBox.shrink(),
              backgroundColor: Colors.white,
              expandedHeight: 210,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: kmainHeadingColor1.withAlpha(90),
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          spreadRadius: 0.8,
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical),
                          child: SizedBox(height: 25),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState.openDrawer();
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.only(left: 15),
                                  child: SvgPicture.asset(
                                    'assets/images/menuIcon.svg',
                                    color: kmainHeadingColor1,
                                    height: 15,
                                    width: 15,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  File image = await Navigator.of(context).push(
                                      CupertinoPageRoute(builder: (context) => MyProfileScreen(user: widget.user, profileImage: _profileImage)));
                                  setState(() {
                                    _profileImage = image;
                                  });
                                  _checkDataConnection();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.only(right: 15),
                                  child: _profileImage != null
                                      ? Hero(
                                          tag: 'Profile Image',
                                          child: ClipOval(
                                              child: FadeInImage(
                                            height: 45,
                                            width: 45,
                                            placeholder: MemoryImage(kTransparentImage),
                                            image: FileImage(_profileImage),
                                            fadeInDuration: Duration(milliseconds: 1000),
                                          )),
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 38,
                                          color: Colors.white,
                                        ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: kmainHeadingColor1.withAlpha(100),
                                        offset: Offset(0, 0),
                                        blurRadius: 6,
                                        spreadRadius: 1.5,
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 25,
                                  right: 15,
                                  bottom: 6,
                                  top: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kappColor1.withAlpha(180),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                                ),
                                child: Text(
                                  getWelcomeText(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 35, top: 5),
                                child: Text(
                                  getUserName(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 33,
                                    color: kmainHeadingColor1.withAlpha(230),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      'Quote of the day',
                      style: TextStyle(fontSize: 23, fontFamily: 'Montserrat', color: kmainHeadingColor2.withAlpha(200), fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      key: UniqueKey(),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: kmainHeadingColor2.withAlpha(150),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(_animController),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      quote ?? '',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat', height: 1.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              author ?? '',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'Montserrat', fontSize: 15),
                            ),
                          ],
                        ),
                      )),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, right: 5),
                                child: Material(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    splashFactory: InkRipple.splashFactory,
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: kappColor.withAlpha(100),
                                    highlightColor: kappColor.withAlpha(100),
                                    onTap: () {
                                      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SearchSpecialistScreen(user: widget.user)));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.width * 0.40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: kappColor.withAlpha(80),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: SvgPicture.asset(
                                                'assets/images/nephrologist.svg',
                                                color: kmainHeadingColor1.withAlpha(220),
                                                height: 60,
                                                width: 60,
                                              )),
                                          Text(
                                            'Search specialist',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: kmainHeadingColor1.withAlpha(220),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, left: 5),
                              child: Material(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: kmainHeadingColor1,
                                  highlightColor: kmainHeadingColor1,
                                  onTap: () async {
                                    await Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MessagesScreen(user: widget.user)));
                                    if (widget.user.runtimeType == Doctor) {
                                      _checkDataConnection();
                                    }
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: kmainHeadingColor1.withAlpha(200),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15, top: 15),
                                          child: SvgPicture.asset(
                                            'assets/images/chat1.svg',
                                            color: Colors.white,
                                            height: 55,
                                            width: 55,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10, bottom: 10),
                                          child: Text('Messages',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Montserrat')),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Material(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(20),
                                splashColor: kheadingColor2,
                                highlightColor: kheadingColor2,
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PharmacyLocatorScreen()));
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: kheadingColor2.withAlpha(180),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15, top: 12),
                                        child: SvgPicture.asset(
                                          'assets/images/hospital.svg',
                                          color: Colors.white,
                                          height: 58,
                                          width: 58,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, bottom: 10),
                                        child: Text(
                                          'Pharmacies',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: Material(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: kheadingColor2.withAlpha(100),
                                  highlightColor: kheadingColor2.withAlpha(100),
                                  onTap: () async {
                                    if (type == Patient) {
                                      await Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MyDoctorsScreen(user: widget.user)));
                                      _checkDataConnection();
                                    } else
                                      await Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MyPatientsScreen(user: widget.user)));
                                    _checkDataConnection();
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width * 0.40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: kappColor1.withAlpha(60),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20, top: 15),
                                          child: SvgPicture.asset(
                                            type == Patient ? 'assets/images/healthcare-medical-healthcare.svg' : 'assets/images/user_profile_2.svg',
                                            color: kheadingColor2,
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10, bottom: 10),
                                          child: Text(
                                            type == Patient ? 'My Doctors' : 'My Patients',
                                            style:
                                                TextStyle(color: kheadingColor2, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 25),
                    child: Text('Recommended for you',
                        style:
                            TextStyle(color: kmainHeadingColor1.withAlpha(200), fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Montserrat')),
                  ),
                  RecommendationSlider(
                    currentUser: widget.user,
                    diseasesList: type == Patient ? widget.user.patientDiseaseList : null,
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      FeatureContainer(
                        heading: 'Drugs info.',
                        description: 'Search Drugs for their uses, side effects and their interaction with other drugs',
                        assetName: 'Icons- pills.svg',
                        padding: EdgeInsets.all(11),
                        color: ksecondaryColor.withAlpha(150),
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => DrugInfoScreen()));
                        },
                      ),
                      FeatureContainer(
                        heading: 'Disease info.',
                        description: 'Search Diseases for their category, effects on body and other useful information about them',
                        assetName: 'virus.svg',
                        padding: EdgeInsets.all(9),
                        color: Colors.indigo.withAlpha(150),
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => DiseaseInfoScreen()));
                        },
                      ),
                      FeatureContainer(
                        heading: 'My Profile',
                        description: 'View and edit your profile information',
                        assetName: 'user_profile_3.svg',
                        padding: EdgeInsets.all(10),
                        color: Colors.deepOrangeAccent.withAlpha(150),
                        onTap: () async {
                          File image = await Navigator.of(context)
                              .push(CupertinoPageRoute(builder: (context) => MyProfileScreen(user: widget.user, profileImage: _profileImage)));
                          setState(() {
                            _profileImage = image;
                          });
                          _checkDataConnection();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(
                    indent: MediaQuery.of(context).size.width * 0.1,
                    endIndent: MediaQuery.of(context).size.width * 0.1,
                  ),
                  AddAlarmRow(),
                ],
              ),
            ),
          ],
        ),
        drawer: HomeScreenDrawer(user: widget.user, profileImage: _profileImage),
      ),
    );
  }
}
