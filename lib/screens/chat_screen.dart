import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/message_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/doctor_detail_screen.dart';
import 'package:patient_assistant_app/screens/patient_detail_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/utils/utils.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.user, this.receiver, this.receiverImage});
  dynamic receiver;
  dynamic user;
  File receiverImage;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DBHelper _dbHelper = DBHelper();
  String get senderName => widget.user.runtimeType == Patient ? widget.user.patientName : widget.user.doctorName;
  String get receiverName => widget.receiver.runtimeType == Patient ? widget.receiver.patientName : widget.receiver.doctorName;
  String get userID => widget.user.runtimeType == Patient ? widget.user.patientID : widget.user.doctorID;
  String get receiverID => widget.receiver.runtimeType == Patient ? widget.receiver.patientID : widget.receiver.doctorID;
  String get doctorID => widget.user.runtimeType == Doctor ? widget.user.doctorID : widget.receiver.doctorID;
  String get patientID => widget.user.runtimeType == Patient ? widget.user.patientID : widget.receiver.patientID;
  Map<String, dynamic> userChat;
  bool isMessageEmpty = true;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  TextEditingController _textController = TextEditingController();
  CollectionReference messagesRef = FirebaseFirestore.instance.collection('messages');

  @override
  void initState() {
    userChat = {'chatID': patientID + doctorID, 'messages': []};
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget showAlert({String alertMessage}) {
    return AlertDialog(
      title: Text('Confirm', style: kdialogTitleStyle),
      content: Text(alertMessage, style: kalertDescriptionStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: <Widget>[
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 80, height: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kappColor1.withAlpha(200)),
            ),
            child: Center(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: kappColor1.withAlpha(200),
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
      onWillPop: () async {
        if (userChat['messages'].length != 0) {
          Map<String, dynamic> encodedChat = encodeChat(userChat);
          await _dbHelper.insertMessagesDB(chatID: patientID + doctorID, messages: encodedChat['messages']);
        }
        return Future<bool>.value(true);
      },
      child: Scaffold(
        key: key,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, right: 10, top: 10),
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  gradient: LinearGradient(
                    colors: [Colors.lightGreen.withAlpha(190), Color(0xff329D9C).withAlpha(190)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            child: SizedBox(
                              height: 25,
                              width: 30,
                              child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1),
                            ),
                            onTap: () async {
                              if (userChat['messages'].length != 0) {
                                Map<String, dynamic> encodedChat = encodeChat(userChat);
                                await _dbHelper.insertMessagesDB(chatID: patientID + doctorID, messages: encodedChat['messages']);
                              }
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            }),
                        SizedBox(width: 25)
                      ],
                    ),
                    Expanded(
                      child: Text(receiverName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 23, color: kmainHeadingColor1, fontWeight: FontWeight.w700)),
                    ),
                    widget.receiver.runtimeType == Doctor
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    AndroidIntent intent = AndroidIntent(
                                      action: 'action_view',
                                      data: Uri.encodeFull('tel:${widget.receiver.doctorPhoneNo}'),
                                    );
                                    if (await intent.canResolveActivity()) {
                                      await intent.launch();
                                    } else {
                                      key.currentState.removeCurrentSnackBar();
                                      key.currentState.showSnackBar(SnackBar(
                                          backgroundColor: Color(0xff2f9f8f),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 3),
                                          content: Row(
                                            children: [
                                              Icon(Icons.not_interested, color: Colors.white, size: 25),
                                              SizedBox(width: 10),
                                              Text('No app found that can complete this actions',
                                                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                                            ],
                                          )));
                                    }
                                  },
                                  child: SizedBox(
                                      height: 25,
                                      width: 30,
                                      child: Icon(
                                        Icons.call,
                                        color: kmainHeadingColor1,
                                        size: 23,
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(CupertinoPageRoute(
                                        builder: (context) => DoctorDetailScreen(
                                              doctor: widget.receiver,
                                              currentUser: widget.user,
                                              profileImage: widget.receiverImage,
                                              fromMessageScreen: true,
                                            )));
                                  },
                                  child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Icon(
                                        Icons.info_outline,
                                        color: kmainHeadingColor1,
                                        size: 23,
                                      ))),
                            ],
                          )
                        : SizedBox(
                            width: 55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: !widget.user.doctorsPatientList.contains(receiverID),
                                  child: GestureDetector(
                                      onTap: () async {
                                        bool confirmed = await showDialog(
                                            context: context,
                                            child: showAlert(alertMessage: 'Are sure you want to add this user to your Patients List.'));
                                        if (confirmed) {
                                          setState(() {
                                            widget.user.doctorsPatientList.remove(null);
                                            widget.user.doctorsPatientList.add(receiverID);
                                          });
                                          await _dbHelper.insertDoctorDB(widget.user);
                                          if (await DataConnectionChecker().hasConnection) {
                                            await FirestoreHandler().saveDoctorFirestore(widget.user);
                                          }
                                          key.currentState.removeCurrentSnackBar();
                                          key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: Color(0xff2f9f8f),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                              behavior: SnackBarBehavior.floating,
                                              duration: Duration(seconds: 3),
                                              content: Row(
                                                children: [
                                                  Icon(Icons.check_circle_sharp, color: Colors.white, size: 25),
                                                  SizedBox(width: 10),
                                                  Text('User addded to your Patients List.',
                                                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                                                ],
                                              )));
                                        }
                                      },
                                      child: SizedBox(
                                          height: 25,
                                          width: 30,
                                          child: Icon(
                                            FontAwesomeIcons.userPlus,
                                            color: kmainHeadingColor1,
                                            size: 18,
                                          ))),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(CupertinoPageRoute(
                                          builder: (context) => PatientDetailScreen(
                                              patient: widget.receiver,
                                              profileImage: widget.receiverImage,
                                              currentUser: widget.user,
                                              fromMessageScreen: true)));
                                    },
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: kmainHeadingColor1,
                                        size: 23,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: messagesRef.doc(patientID + doctorID).snapshots(),
                // ignore: missing_return
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data.data() != null) {
                    List<Widget> textWidget = [];
                    Map<String, dynamic> data = decodeChat(snapshot.data.data());
                    userChat.clear();
                    userChat.addAll(data);
                    for (Message message in data['messages'].reversed) {
                      textWidget.add(
                        MessageBubble(
                          message: message,
                          userID: userID,
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        shrinkWrap: true,
                        children: textWidget,
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: 50,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          controller: _textController,
                          cursorColor: kappColor1.withAlpha(10),
                          cursorWidth: 1,
                          maxLines: null,
                          style: TextStyle(color: kappColor1, fontSize: 18, fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                              hintText: 'Type message here',
                              hintStyle: TextStyle(fontSize: 17, fontFamily: 'Montserrat', color: Color(0xff46A98C).withAlpha(100)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kappColor1.withAlpha(100), width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kappColor1.withAlpha(40), width: 1),
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onChanged: (String text) {
                            setState(() {
                              isMessageEmpty = text.isEmpty ? true : false;
                            });
                          },
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 12, bottom: 10, right: 3),
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        if (!isMessageEmpty) {
                          Message messageObj = Message(
                              sender: userID,
                              receiver: receiverID,
                              senderName: senderName,
                              receiverName: receiverName,
                              message: _textController.text,
                              dateTime: DateTime.now());
                          _textController.clear();
                          userChat['chatID'] = patientID + doctorID;
                          userChat['messages'].add(messageObj);
                          Map<String, dynamic> encodedChat = encodeChat(userChat);
                          await messagesRef.doc(patientID + doctorID).set(encodedChat);
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/images/send.svg',
                        height: 15,
                        width: 15,
                        color: isMessageEmpty ? Color(0xff46A98C).withAlpha(100) : Color(0xff46A98C),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({@required this.message, @required this.userID});

  final Message message;
  final String userID;
  BoxDecoration get bubbleDecoration => userID == message.sender ? ksenderMessageDecoration : kreceiverMessageDecoration;
  Color get textColor => userID == message.sender ? Colors.white : kmainHeadingColor1.withAlpha(200);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: UniqueKey(),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: userID == message.sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Text(
              message.message,
              style: TextStyle(color: textColor, fontSize: 16, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
            ),
            decoration: bubbleDecoration,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            child:
                Text(getDateTimeString(message.dateTime), style: TextStyle(color: Colors.grey, fontSize: 10, height: 1, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
