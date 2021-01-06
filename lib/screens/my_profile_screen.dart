import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/widgets/doctor_profile.dart';
import 'package:patient_assistant_app/widgets/patient_profile.dart';

// ignore: must_be_immutable
class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({this.user, this.profileImage});
  dynamic user;
  File profileImage;
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  File oldImage;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Future<void> getProfileImage(ImageSource source) async {
    final PickedFile _pickedFile = await ImagePicker().getImage(source: source);
    if (_pickedFile != null) {
      if (File(_pickedFile.path).lengthSync() >= 1258300 && File(_pickedFile.path).lengthSync() <= 1258300 * 2) {
        var result = await FlutterImageCompress.compressAndGetFile(
          _pickedFile.path,
          _pickedFile.path + 'compressed.jpeg',
          quality: 80,
        );
        setState(() {
          widget.profileImage = result;
        });
      } else if (File(_pickedFile.path).lengthSync() >= 1258300 * 2) {
        var result = await FlutterImageCompress.compressAndGetFile(
          _pickedFile.path,
          _pickedFile.path + 'compressed.jpeg',
          quality: 50,
        );
        setState(() {
          widget.profileImage = result;
        });
      } else {
        setState(() {
          widget.profileImage = File(_pickedFile.path);
        });
      }
    }
  }

  Future<void> _cropImage() async {
    final File croppedImage = await ImageCropper.cropImage(
      sourcePath: widget.profileImage.path,
      compressQuality: widget.profileImage.lengthSync() > 1048576 ? 40 : 80,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: 'Crop Image',
        toolbarWidgetColor: kprimaryColor,
        statusBarColor: Colors.black54,
        activeControlsWidgetColor: kprimaryColor,
      ),
    );
    setState(() {
      widget.profileImage = croppedImage ?? widget.profileImage;
    });
  }

  Widget addImageBottomSheet(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Profile Photo',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await getProfileImage(ImageSource.gallery);
                  if (widget.profileImage != null && widget.profileImage != oldImage) {
                    await _cropImage();
                    setState(() {
                      oldImage = widget.profileImage;
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Icon(
                          Icons.image,
                          size: 20,
                          color: Color(0xfffcfcfc),
                        ),
                        constraints: BoxConstraints.tightFor(height: 40, width: 40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xff642B73), Color(0xffC6426E)]),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 5),
                        child: Text('Gallery', style: TextStyle(fontFamily: 'Arial', color: Colors.black54)),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await getProfileImage(ImageSource.camera);
                  if (widget.profileImage != null && oldImage != widget.profileImage) {
                    await _cropImage();
                    setState(() {
                      oldImage = widget.profileImage;
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Color(0xfffcfcfc),
                        ),
                        constraints: BoxConstraints.tightFor(height: 40, width: 40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xff202066), Color(0xff1CB5E0)]),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 5),
                        child: Text('Camera', style: TextStyle(fontFamily: 'Arial', color: Colors.black54)),
                      ),
                    ],
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
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(widget.profileImage);
        return Future<bool>.value(true);
      },
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
          SliverAppBar(
            leading: GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 25,
                  width: 25,
                  child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1),
                ),
                onTap: () {
                  Navigator.of(context).pop(widget.profileImage);
                }),
            expandedHeight: 200,
            toolbarHeight: 140,
            backgroundColor: Colors.white,
            flexibleSpace: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).viewPadding.vertical + 200,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    gradient: LinearGradient(
                      colors: [Colors.lightGreen.withAlpha(190), Color(0xff329D9C).withAlpha(190)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Container(
                          height: 115,
                          width: 115,
                          child: widget.profileImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    widget.profileImage,
                                    fit: BoxFit.cover,
                                  ))
                              : Icon(
                                  Icons.account_box,
                                  size: 100,
                                  color: kheadingColor2,
                                ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black38, offset: Offset(0, 3), blurRadius: 5, spreadRadius: 1)]),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                context: _key.currentContext,
                                builder: (context) => addImageBottomSheet(_key.currentContext));
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff44A08D), Color(0xff093637)],
                                begin: Alignment.centerLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              color: kheadingColor2,
                            ),
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.edit,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                widget.user.runtimeType == Patient
                    ? PatientProfile(user: widget.user, profileImage: widget.profileImage)
                    : DoctorProfile(user: widget.user, profileImage: widget.profileImage)
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
