import 'dart:async';

import 'package:animations/animations.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/utils/utils.dart';
import 'package:patient_assistant_app/widgets/chat_card.dart';
import 'package:patient_assistant_app/widgets/contact_tile.dart';

// ignore: must_be_immutable
class MessagesScreen extends StatefulWidget {
  MessagesScreen({this.user});
  dynamic user;
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String get userID => widget.user.runtimeType == Patient ? widget.user.patientID : widget.user.doctorID;
  DBHelper _dbHelper = DBHelper();
  FirestoreHandler _firestoreHandler = FirestoreHandler();
  List<String> userContacts = [];
  List<Doctor> userDoctors = [];
  List<Patient> userPatients = [];
  List<Widget> contactWidgets = [];
  List<Map<String, dynamic>> userChat = [];

  @override
  initState() {
    getUserChatFirestore();
    super.initState();
  }

  Future<void> getUserChatFirestore() async {
    List<Map<String, dynamic>> userChatFirestore = await _firestoreHandler.getUserMessagesFirestore(userID);
    if (userChatFirestore.length != 0) {
      if (userChatFirestore.length > 1) {
        userChatFirestore.sort((a, b) {
          return a['messages'].last.dateTime.compareTo(b['messages'].last.dateTime);
        });
      }
      setState(() {
        userChat = userChatFirestore;
      });
      await _dbHelper.insertUserChatDB(chats: userChatFirestore);
    }
  }

  Future<void> loadUserChatDB() async {
    userChat.clear();
    List<Map<String, dynamic>> chats = await _dbHelper.readUserChatDB(userID);
    List<Map<String, dynamic>> temp = decodeMessagesObjects(chats);
    if (temp.length != 0) {
      if (temp.length > 1) {
        temp.sort((a, b) {
          return a['messages'].last.dateTime.compareTo(b['messages'].last.dateTime);
        });
      }
      setState(() {
        userChat = temp;
      });
    }
  }

  Future<void> loadContacts() async {
    userContacts.clear();
    contactWidgets.clear();
    userDoctors.clear();
    userPatients.clear();
    if (widget.user.runtimeType == Patient) {
      if (widget.user.patientsDoctorList.length != 0) {
        userContacts.addAll(widget.user.patientsDoctorList);
      }
    } else {
      if (widget.user.doctorsPatientList.length != 0) {
        userContacts.addAll(widget.user.doctorsPatientList);
      }
    }
    if (widget.user.runtimeType == Doctor) {
      List<Patient> patients = await _dbHelper.readAllPatients();
      if (patients.length != 0) {
        for (Patient patient in patients) {
          if (userContacts.contains(patient.patientID)) {
            userPatients.add(patient);
          }
        }
        setState(() {
          for (Patient contact in userPatients) {
            contactWidgets.add(
              ContactTile(contact: contact, user: widget.user),
            );
          }
        });
      }
    } else {
      List<Doctor> doctors = await _dbHelper.readAllDoctors();
      if (doctors.length != 0) {
        for (Doctor doctor in doctors) {
          if (userContacts.contains(doctor.doctorID)) {
            userDoctors.add(doctor);
          }
        }
        setState(() {
          for (Doctor contact in userDoctors) {
            contactWidgets.add(
              ContactTile(contact: contact, user: widget.user),
            );
          }
        });
      }
    }
  }

  @override
  void didChangeDependencies() async {
    await loadUserChatDB();
    await loadContacts();
    super.didChangeDependencies();
  }

  Widget showAlert(BuildContext context) {
    return AlertDialog(
      title: Text('Alert !', style: kdialogTitleStyle),
      content: Text('Your are not connected to Internet. Please check your connection and try again.', style: kalertDescriptionStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: <Widget>[
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 48, height: 48),
            decoration: kAlertBtnDecoration,
            child: Center(
              child: Text(
                'ok',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget noChatIllustration(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 50),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/empty_inbox.svg', height: MediaQuery.of(context).size.height * 0.4),
          SizedBox(height: 20),
          Text(
            'No messages found. Click on the floating button to start a conversation',
            textAlign: TextAlign.center,
            style: kdialogContentStyle,
          ),
        ],
      ),
    );
  }

  Widget noContactIllustration({BuildContext context, dynamic type}) {
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
            type == Patient
                ? 'Looks like you have not added any Specialist to your profile. To contact your specialist first you will need to add them to your profile'
                : 'Currently you don\'t have any Patients. You can add them to your profile once they contact you.',
            textAlign: TextAlign.center,
            style: kdialogContentStyle,
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
        return Future.value(true);
      },
      child: Scaffold(
        key: UniqueKey(),
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
                    child: SizedBox(height: 25, width: 25, child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1)),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5),
                  child: Text(
                    'Messages',
                    style: TextStyle(fontSize: 32, fontFamily: 'Montserrat', fontWeight: FontWeight.w900, color: kmainHeadingColor1),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            bool connection = await DataConnectionChecker().hasConnection;
            if (connection) {
              getUserChatFirestore();
            } else {
              showDialog(context: context, child: showAlert(context));
            }
          },
          child: userChat.length == 0
              ? ListView(children: [noChatIllustration(context)])
              : Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      key: UniqueKey(),
                      itemCount: userChat.length,
                      // ignore: missing_return
                      itemBuilder: (context, index) {
                        if (userChat[index]['messages'].length != 0) {
                          return ChatCard(chat: userChat[index], receiverID: userChat[index]['chatID'].replaceAll(userID, ''), user: widget.user);
                        }
                      }),
                ),
        ),
        floatingActionButton: OpenContainer(
          closedShape: CircleBorder(),
          closedBuilder: (context, openContainer) {
            return GestureDetector(
              onTap: openContainer,
              child: Container(
                height: 55,
                width: 55,
                child: Icon(Icons.comment, color: Colors.white, size: 30),
                decoration: kAlertBtnDecoration,
              ),
            );
          },
          openBuilder: (context, closeContainer) {
            return Column(
              key: ValueKey('openContainer'),
              children: [
                Container(
                  height: 150,
                  padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 15, left: 15, right: 15, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: SizedBox(height: 25, width: 25, child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1)),
                        onTap: closeContainer,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              userContacts.length == 0 ? 'No contacts found' : 'Select Contact',
                              style: TextStyle(fontSize: 32, fontFamily: 'Montserrat', fontWeight: FontWeight.w900, color: kappColor1),
                            ),
                          ),
                          Row(
                            children: userContacts.length == 0
                                ? []
                                : [
                                    Text('The following are from your ', style: kalertDescriptionStyle),
                                    Text(widget.user.runtimeType == Patient ? 'My Doctors' : 'My Patients',
                                        style: kalertDescriptionStyle.copyWith(fontWeight: FontWeight.w900)),
                                    Text(' List', style: kalertDescriptionStyle),
                                  ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  height: MediaQuery.of(context).size.height - 150,
                  width: MediaQuery.of(context).size.width,
                  child: userContacts.length == 0
                      ? noContactIllustration(context: context, type: widget.user.runtimeType)
                      : SingleChildScrollView(
                          child: contactWidgets.length == 0
                              ? Container(
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: contactWidgets,
                                ),
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
