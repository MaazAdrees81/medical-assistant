import 'dart:io';

import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/chat_screen.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:transparent_image/transparent_image.dart';

class ContactTile extends StatefulWidget {
  ContactTile({this.contact, this.user});
  final dynamic contact;
  final dynamic user;
  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  File _profileImage;

  @override
  initState() {
    getProfileImage(widget.contact.runtimeType == Patient ? widget.contact.patientID : widget.contact.doctorID);
    super.initState();
  }

  getProfileImage(String userID) async {
    File temp = await FirebaseStorageHelper().getLocalProfileImage(userID: userID);
    if (temp == null) {
      temp = await FirebaseStorageHelper().downloadProfileImage(userID: userID);
    }
    precacheImage(FileImage(temp), context);
    setState(() {
      _profileImage = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => ChatScreen(user: widget.user, receiver: widget.contact, receiverImage: _profileImage)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: FileImage(_profileImage),
                            fadeInDuration: Duration(milliseconds: 500),
                          ),
                        )
                      : SvgPicture.asset('assets/images/user_profile_9.svg', height: 30, width: 30, color: kheadingColor2.withAlpha(100)),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.contact.runtimeType == Patient ? widget.contact.patientName : widget.contact.doctorName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kmainHeadingColor1,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(indent: 75, endIndent: 15, height: 0)
          ],
        ),
      ),
    );
  }
}
