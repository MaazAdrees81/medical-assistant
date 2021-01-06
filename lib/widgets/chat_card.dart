import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/chat_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/utils/utils.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class ChatCard extends StatefulWidget {
  ChatCard({this.receiverID, this.user, this.chat});
  Map<String, dynamic> chat;
  String receiverID;
  dynamic user;

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String get userID => widget.user.runtimeType == Patient ? widget.user.patientID : widget.user.doctorID;
  String get doctorID => widget.user.runtimeType == Doctor ? widget.user.doctorID : widget.receiverID;
  String get patientID => widget.user.runtimeType == Patient ? widget.user.patientID : widget.receiverID;
  dynamic receiver;
  File _profileImage;
  int newMessages = 0;
  CollectionReference messagesRef = FirebaseFirestore.instance.collection('messages');

  @override
  initState() {
    getReceiver();
    getProfileImage(widget.receiverID);
    chatStream();
    super.initState();
  }

  getReceiver() async {
    if (widget.user.runtimeType == Patient) {
      dynamic temp = await DBHelper().readDoctorData(widget.receiverID);
      if (temp == null) {
        temp = await FirestoreHandler().getDoctorFirestore(widget.receiverID);
        await DBHelper().insertDoctorDB(temp);
      }
      setState(() {
        receiver = temp;
      });
    } else {
      dynamic temp = await DBHelper().readPatientData(widget.receiverID);
      if (temp == null) {
        temp = await FirestoreHandler().getPatientFirestore(widget.receiverID);
        await DBHelper().insertPatientDB(temp);
      }
      setState(() {
        receiver = temp;
      });
    }
  }

  chatStream() async {
    if (await DataConnectionChecker().hasConnection) {
      await for (DocumentSnapshot snapshot in messagesRef.doc(patientID + doctorID).snapshots()) {
        if (snapshot.data() != null || snapshot.data().isNotEmpty) {
          setState(() {
            widget.chat = decodeChat(snapshot.data());
          });
        }
      }
    }
  }

  getProfileImage(String userID) async {
    File temp = await FirebaseStorageHelper().getLocalProfileImage(userID: userID);
    if (temp == null) {
      temp = await FirebaseStorageHelper().downloadProfileImage(userID: userID);
    }
    precacheImage(FileImage(temp), Scaffold.of(context).context);
    setState(() {
      _profileImage = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (receiver != null) {
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (context) => ChatScreen(user: widget.user, receiver: receiver, receiverImage: _profileImage)));
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 15),
        height: 90,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
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
                          borderRadius: BorderRadius.circular(15),
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: FileImage(_profileImage),
                            fadeInDuration: Duration(milliseconds: 500),
                          ),
                        )
                      : SvgPicture.asset('assets/images/user_profile_9.svg', height: 45, width: 55, color: kheadingColor2.withAlpha(100)),
                ),
                Expanded(
                  child: Container(
                    height: 75,
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.chat['messages'].last.sender == userID
                              ? widget.chat['messages'].last.receiverName
                              : widget.chat['messages'].last.senderName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xff2C385B),
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.chat['messages'].last.sender == userID
                                        ? 'you: '
                                        : '${widget.chat['messages'].last.senderName.toLowerCase()}: ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, color: kheadingColor2),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.chat['messages'].last.message,
                                    overflow: TextOverflow.ellipsis,
                                    style: kdescriptionStyle,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateTimeString(widget.chat['messages'].last.dateTime),
                        style: kdescriptionStyle,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      newMessages != 0
                          ? Container(
                              padding: EdgeInsets.only(left: 8, right: 7, top: 6, bottom: 4),
                              child: Text(
                                '$newMessages',
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              decoration: BoxDecoration(color: kappColor1, borderRadius: BorderRadius.circular(10)),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 15,
              indent: 30,
              endIndent: 45,
            ),
          ],
        ),
      ),
    );
  }
}
