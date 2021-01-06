import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/utils/widget_size_measurer.dart';
import 'package:patient_assistant_app/widgets/doctor_form.dart';
import 'package:patient_assistant_app/widgets/patient_form.dart';

class FormScreen extends StatefulWidget {
  FormScreen({@required this.userId, @required this.userEmail});
  final String userId;
  final String userEmail;

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int isSelected = 0;
  Size _cardSize;
  File displayImage;
  File oldImage;

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
          displayImage = result;
        });
      } else if (File(_pickedFile.path).lengthSync() >= 1258300 * 2) {
        var result = await FlutterImageCompress.compressAndGetFile(
          _pickedFile.path,
          _pickedFile.path + 'compressed.jpeg',
          quality: 50,
        );
        setState(() {
          displayImage = result;
        });
      } else {
        setState(() {
          displayImage = File(_pickedFile.path);
        });
      }
    }
  }

  Future<void> _cropImage() async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: displayImage.path,
      compressQuality: displayImage.lengthSync() > 1048576 ? 40 : 80,
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
      displayImage = croppedImage ?? displayImage;
    });
  }

  Widget addImageBottomSheet() {
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
              displayImage != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          displayImage = null;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Color(0xfffcfcfc),
                              ),
                              constraints: BoxConstraints.tightFor(height: 40, width: 40),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xff553333), Color(0xffdd1818)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10, top: 5),
                              child: Text('Remove Photo', style: TextStyle(fontFamily: 'Arial', color: Colors.black54)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(width: 1, height: 1),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await getProfileImage(ImageSource.gallery);
                  if (displayImage != null && displayImage != oldImage) {
                    await _cropImage();
                    setState(() {
                      oldImage = displayImage;
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
                  if (displayImage != null && oldImage != displayImage) {
                    await _cropImage();
                    setState(() {
                      oldImage = displayImage;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10, top: MediaQuery.of(context).viewPadding.vertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: FittedBox(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Container(
                          height: 115,
                          width: 115,
                          child: displayImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    displayImage,
                                    fit: BoxFit.cover,
                                  ))
                              : Icon(
                                  Icons.account_box,
                                  size: 100,
                                  color: Colors.white,
                                ),
                          decoration: BoxDecoration(
                            boxShadow: displayImage != null
                                ? [
                                    BoxShadow(
                                      color: kmainHeadingColor1.withAlpha(100),
                                      offset: Offset(0, 2),
                                      blurRadius: 6,
                                      spreadRadius: 1.5,
                                    )
                                  ]
                                : null,
                            gradient: LinearGradient(
                              colors: [Color(0xff2C3E50), Color(0xff4CA1AF)],
                              end: Alignment.bottomRight,
                              begin: Alignment.centerLeft,
                            ),
                            color: displayImage != null ? Colors.white : Colors.white30,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                context: context,
                                builder: (context) => addImageBottomSheet());
                          },
                          child: Container(
                            width: 33,
                            height: 33,
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
                              Icons.add_a_photo,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
                child: displayImage == null
                    ? Text(
                        '(Please select a Profile Picture to proceed next)',
                        style: TextStyle(fontSize: 12, fontFamily: 'Spartan', fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      )
                    : null,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected = 0;
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 50,
                        decoration: isSelected == 0 ? kSelectedFormDecoration : kUnselectedFormDecoration,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                          Icon(
                            FontAwesomeIcons.userMd,
                            size: 30,
                            color: isSelected == 0 ? Colors.white : Colors.blueGrey.withAlpha(140),
                          ),
                          Text(
                            'Doctor',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: isSelected == 0 ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                              color: isSelected == 0 ? Colors.white : Colors.blueGrey.withAlpha(140),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected = 1;
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 50,
                        decoration: isSelected == 1 ? kSelectedFormDecoration : kUnselectedFormDecoration,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                          Icon(
                            FontAwesomeIcons.userInjured,
                            size: 30,
                            color: isSelected == 1 ? Colors.white : Colors.blueGrey.withAlpha(140),
                          ),
                          Text(
                            'Patient',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: isSelected == 1 ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                              color: isSelected == 1 ? Colors.white : Colors.blueGrey.withAlpha(140),
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              PageTransitionSwitcher(
                child: isSelected == 0
                    ? MeasureSize(
                        onChange: (size) {
                          setState(() {
                            _cardSize = size;
                          });
                        },
                        child: DoctorForm(userId: widget.userId, profileImage: displayImage))
                    : SizedBox(
                        height: _cardSize.height,
                        child: PatientForm(userId: widget.userId, profileImage: displayImage),
                      ),
                duration: Duration(milliseconds: 800),
                reverse: isSelected == 0 ? true : false,
                transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    fillColor: Colors.white,
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
