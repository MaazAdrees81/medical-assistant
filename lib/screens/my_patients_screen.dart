import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/patient_card.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class MyPatientsScreen extends StatefulWidget {
  MyPatientsScreen({this.user});
  Doctor user;

  @override
  _MyPatientsScreenState createState() => _MyPatientsScreenState();
}

class _MyPatientsScreenState extends State<MyPatientsScreen> {
  List<Patient> myPatientsList = [];
  @override
  void initState() {
    getPatientsData();
    super.initState();
  }

  getPatientsData() async {
    List<Patient> patientList = [];
    if (widget.user.doctorsPatientList.length != 0) {
      for (String patientID in widget.user.doctorsPatientList) {
        Patient patient = await FirestoreHandler().getPatientFirestore(patientID);
        patientList.add(patient);
      }
      setState(() {
        myPatientsList.addAll(patientList);
      });
    }
  }

  Widget noPatientIllustration() {
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
            'There are currently no Patients in your profile. You can add to your Patients List when they contact.',
            textAlign: TextAlign.center,
            style: kdialogContentStyle,
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

  Widget shimmeringContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: kmainHeadingColor1.withAlpha(40), blurRadius: 8)],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                height: 75,
                width: 75,
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
          SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  height: 30,
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
                  margin: EdgeInsets.only(top: 10),
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
                  margin: EdgeInsets.only(top: 5),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'My Patients',
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
        child: widget.user.doctorsPatientList.length == 0
            ? noPatientIllustration()
            : ListView.builder(
                itemCount: widget.user.doctorsPatientList.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      myPatientsList.length == 0
                          ? shimmeringContainer(context)
                          : Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 10),
                              child: Dismissible(
                                onDismissed: (DismissDirection direction) async {
                                  setState(() {
                                    widget.user.doctorsPatientList.removeAt(index);
                                    myPatientsList.removeAt(index);
                                  });
                                  await DBHelper().insertDoctorDB(widget.user);
                                },
                                confirmDismiss: (DismissDirection direction) {
                                  Future<bool> toDismiss = showDialog(
                                      context: context,
                                      child: showAlert(
                                          alertMessage: 'Are you sure you want to remove this User from your List of Doctors',
                                          context: context,
                                          index: index));
                                  return toDismiss;
                                },
                                background: Container(
                                  padding: EdgeInsets.only(left: 30),
                                  color: Color(0xffdd1818).withAlpha(180),
                                  child:
                                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [Icon(Icons.delete, color: Colors.white, size: 50)]),
                                ),
                                secondaryBackground: Container(
                                  padding: EdgeInsets.only(right: 30),
                                  color: Color(0xffdd1818).withAlpha(180),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Icon(Icons.delete, color: Colors.white, size: 50)]),
                                ),
                                key: UniqueKey(),
                                child: PatientCard(patient: myPatientsList[index], user: widget.user),
                              ),
                            ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
