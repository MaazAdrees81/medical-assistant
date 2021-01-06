import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/search_specialist_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/recommendation_card.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class MyDoctorsScreen extends StatefulWidget {
  MyDoctorsScreen({this.user});
  Patient user;
  @override
  _MyDoctorsScreenState createState() => _MyDoctorsScreenState();
}

class _MyDoctorsScreenState extends State<MyDoctorsScreen> {
  List<Doctor> myDoctorsList = [];
  @override
  void initState() {
    getDoctorsData();
    super.initState();
  }

  getDoctorsData() async {
    List<Doctor> docList = [];
    if (widget.user.patientsDoctorList.length != 0) {
      for (String doctorID in widget.user.patientsDoctorList) {
        Doctor doc = await FirestoreHandler().getDoctorFirestore(doctorID);
        docList.add(doc);
      }
      setState(() {
        myDoctorsList.addAll(docList);
      });
    }
  }

  Widget shimmeringContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, bottom: 15, top: 5),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            margin: EdgeInsets.only(left: 25),
            padding: EdgeInsets.only(left: 60, top: 15),
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width * 0.78,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: kmainHeadingColor1.withAlpha(30), offset: Offset(0, 3), blurRadius: 10, spreadRadius: 1)],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                height: 70,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: kmainHeadingColor1.withAlpha(40),
                      offset: Offset(-3, 0),
                      blurRadius: 9,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showAlert({String alertMessage, BuildContext context, int index}) {
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

  Widget noDoctorIllustration() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 20, top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/user_group.svg', height: MediaQuery.of(context).size.height * 0.33),
          SizedBox(height: 15),
          Text(
            'Looks like you have not added any Specialist to your profile. Head over to search screen to add some specialists.',
            textAlign: TextAlign.center,
            style: kdialogContentStyle,
          ),
          SizedBox(height: 50),
          InkWell(
            splashColor: Colors.white,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              await Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SearchSpecialistScreen(user: widget.user)));
              Patient readPatient = await DBHelper().readPatientData(widget.user.patientID);
              if (ListEquality().equals(widget.user.patientsDoctorList, readPatient.patientsDoctorList)) {
                setState(() {
                  widget.user.patientsDoctorList = readPatient.patientsDoctorList;
                });
                getDoctorsData();
              }
            },
            child: Container(
              height: 40,
              width: 110,
              decoration: kGetStartedButton,
              child: Center(
                child: Text(
                  'Lets Go',
                  style: kloginBtn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future<bool>.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'My Doctors',
                    style: TextStyle(fontSize: 32, fontFamily: 'Montserrat', fontWeight: FontWeight.w900, color: kmainHeadingColor1),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          child: widget.user.patientsDoctorList.length == 0
              ? noDoctorIllustration()
              : ListView.builder(
                  itemCount: widget.user.patientsDoctorList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return myDoctorsList.length == 0
                        ? shimmeringContainer(context)
                        : Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 10),
                            child: Dismissible(
                              onDismissed: (DismissDirection direction) async {
                                setState(() {
                                  widget.user.patientsDoctorList.removeAt(index);
                                  myDoctorsList.removeAt(index);
                                });
                                await DBHelper().insertPatientDB(widget.user);
                              },
                              confirmDismiss: (DismissDirection direction) {
                                Future<bool> toDismiss = showDialog(
                                    context: context,
                                    child: showAlert(
                                        alertMessage: 'Are you sure you want to remove this Doctor from your List of Doctors',
                                        context: context,
                                        index: index));
                                return toDismiss;
                              },
                              background: Container(
                                padding: EdgeInsets.only(left: 30),
                                color: Color(0xffdd1818).withAlpha(180),
                                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Icon(Icons.delete, color: Colors.white, size: 50)]),
                              ),
                              secondaryBackground: Container(
                                padding: EdgeInsets.only(right: 30),
                                color: Color(0xffdd1818).withAlpha(180),
                                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Icon(Icons.delete, color: Colors.white, size: 50)]),
                              ),
                              key: UniqueKey(),
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: RecommendationCard(doctor: myDoctorsList[index], currentUser: widget.user),
                              ),
                            ),
                          );
                  },
                ),
        ),
      ),
    );
  }
}
