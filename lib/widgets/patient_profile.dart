import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';

// ignore: must_be_immutable
class PatientProfile extends StatefulWidget {
  PatientProfile({this.user, this.profileImage});
  dynamic user;
  File profileImage;
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  bool _showIndicator = false;
  bool _uploadingTask = false;
  TextStyle valueStyle = TextStyle(height: 1.5, color: kprimaryColor, fontSize: 19, fontWeight: FontWeight.w500);
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  FocusNode _cityNode = FocusNode();
  FocusNode _ageNode = FocusNode();
  FocusNode _diseaseNode = FocusNode();
  String patientName;
  String patientCountry;
  String patientCity;
  String patientAge;
  List<String> diseases = List();
  bool _nameEnabler = false;
  bool _cityEnabler = false;
  bool _diseaseEnabler = false;
  String nameErrorText;
  String ageErrorText;
  String cityErrorText;
  File oldProfileImage;

  @override
  void initState() {
    oldProfileImage = widget.profileImage;
    patientName = widget.user.patientName;
    patientCountry = widget.user.patientCountry;
    patientCity = widget.user.patientCity;
    patientAge = widget.user.patientAge;
    diseases.addAll(widget.user.patientDiseaseList);
    _nameController.text = patientName;
    _cityController.text = patientCity;
    _ageController.text = patientAge;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _diseaseController.dispose();
    _nameNode.dispose();
    _cityNode.dispose();
    _ageNode.dispose();
    _diseaseNode.dispose();
    super.dispose();
  }

  bool isVisible() {
    bool visibility = false;
    if (oldProfileImage != widget.profileImage ||
        patientName != widget.user.patientName ||
        patientCountry != widget.user.patientCountry ||
        patientCity != widget.user.patientCity ||
        patientAge != widget.user.patientAge ||
        !ListEquality().equals(diseases, widget.user.patientDiseaseList)) {
      if (widget.profileImage != null && diseases.length != 0) {
        visibility = true;
      }
    }
    return visibility;
  }

  List<Widget> drawDiseaseColumn() {
    List<Widget> diseaseColumnList = <Widget>[];
    if (diseases.length != 0) {
      for (String disease in diseases) {
        diseaseColumnList.add(Container(
          height: 30,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          decoration: BoxDecoration(
            gradient: ksearchScreenGradient,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  disease,
                  style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5, left: 5),
                child: GestureDetector(
                  onTap: !_showIndicator
                      ? () {
                          setState(() {
                            diseases.remove(disease);
                          });
                        }
                      : null,
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    }
    return diseaseColumnList;
  }

  void _validateAllFields() {
    if (patientName == null || patientName == '') {
      setState(() {
        nameErrorText = 'This is a required field';
      });
    } else if (!RegExp(r'^[a-zA-z.]+([\s][a-zA-Z]+)*$').hasMatch(patientName)) {
      setState(() {
        nameErrorText = 'This is not a valid name';
      });
    } else {
      setState(() {
        nameErrorText = null;
      });
    }
    if (patientAge == '' || patientAge == null) {
      setState(() {
        ageErrorText = 'This field is required';
      });
    } else if (int.parse(patientAge) >= 100) {
      setState(() {
        ageErrorText = 'Age is too large';
      });
    } else if (int.parse(patientAge) <= 14) {
      setState(() {
        ageErrorText = 'Age is too small';
      });
    } else {
      setState(() {
        ageErrorText = null;
      });
    }
    if (patientCity == '' || patientCity == null) {
      setState(() {
        cityErrorText = 'This is a required field';
      });
    } else {
      setState(() {
        cityErrorText = null;
      });
    }
  }

  Widget showAlert({String alertMessage, BuildContext context}) {
    return AlertDialog(
      title: Text('Alert !', style: kdialogTitleStyle),
      content: Text(
          'Profile could not be updated in Cloud because network is not Available. Once the network becomes available the data will automatically be updated with cloud in background',
          style: kalertDescriptionStyle),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Name:',
                  style: TextStyle(fontSize: 17, color: nameErrorText == null ? kmainHeadingColor1 : kerrorColor),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  style: valueStyle,
                  readOnly: !_nameEnabler && !_showIndicator,
                  controller: _nameController,
                  focusNode: _nameNode,
                  cursorColor: kprimaryColor,
                  cursorWidth: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  onChanged: (String value) {
                    patientName = value;
                  },
                  onEditingComplete: () {
                    _nameNode.unfocus();
                    _nameEnabler = false;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    errorText: nameErrorText,
                    isCollapsed: true,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit, color: nameErrorText == null ? kmainHeadingColor1 : kerrorColor),
                  onPressed: !_showIndicator
                      ? () {
                          setState(() {
                            _nameEnabler = true;
                          });
                          _nameNode.requestFocus();
                        }
                      : null)
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    ageErrorText == null ? 'Age: ' : ageErrorText,
                    style: TextStyle(fontSize: 17, color: ageErrorText == null ? kmainHeadingColor1 : kerrorColor),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: !_showIndicator
                                ? () {
                                    setState(() {
                                      patientAge = (int.parse(patientAge) - 1).toString();
                                    });
                                  }
                                : null,
                            child: SizedBox(
                              height: 20,
                              child: Icon(
                                Icons.remove,
                                color: ageErrorText == null ? kmainHeadingColor1 : kerrorColor,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(patientAge, style: valueStyle),
                            ],
                          ),
                          GestureDetector(
                            onTap: !_showIndicator
                                ? () {
                                    setState(() {
                                      patientAge = (int.parse(patientAge) + 1).toString();
                                    });
                                  }
                                : null,
                            child: SizedBox(
                              height: 20,
                              child: Icon(
                                Icons.add,
                                color: ageErrorText == null ? kmainHeadingColor1 : kerrorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.white70),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    'Country:',
                    style: TextStyle(fontSize: 17, color: kmainHeadingColor1),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: AbsorbPointer(
                    absorbing: _showIndicator,
                    child: DropdownSearch(
                      showSelectedItem: true,
                      popupBackgroundColor: Colors.white,
                      mode: Mode.DIALOG,
                      items: PracticeData.countryInfo.keys.toList(),
                      dropDownButton: Icon(
                        Icons.arrow_drop_down,
                        color: kmainHeadingColor1,
                        size: 30,
                      ),
                      showSearchBox: true,
                      selectedItem: patientCountry,
                      popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: kprimaryColor,
                          )),
                      dropdownBuilder: (context, _doctorPracticeType, String value) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            value,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              color: kprimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),
                          ),
                        );
                      },
                      popupItemBuilder: (context, _doctorPracticeType, isSelected) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15, top: 20),
                          child: Text(_doctorPracticeType,
                              style: TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 15,
                              )),
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          patientCountry = value;
                        });
                      },
                      searchBoxDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Country',
                        labelStyle: TextStyle(color: kprimaryColor, fontSize: 15, height: 1.2),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kprimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.green.shade100,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        isCollapsed: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'City:',
                  style: TextStyle(fontSize: 17, color: cityErrorText == null ? kmainHeadingColor1 : kerrorColor),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  style: valueStyle,
                  readOnly: !_cityEnabler,
                  controller: _cityController,
                  focusNode: _cityNode,
                  cursorColor: kprimaryColor,
                  cursorWidth: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  onChanged: (String value) {
                    patientCity = value;
                  },
                  onEditingComplete: () {
                    _cityNode.unfocus();
                    _cityEnabler = false;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    errorText: cityErrorText,
                    isCollapsed: true,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit, color: cityErrorText == null ? kmainHeadingColor1 : kerrorColor),
                  onPressed: !_showIndicator
                      ? () {
                          setState(() {
                            _cityEnabler = true;
                          });
                          _cityNode.requestFocus();
                        }
                      : null),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Diseases:',
                  style: TextStyle(fontSize: 17, color: kmainHeadingColor1),
                ),
              ),
              Visibility(
                visible: _diseaseEnabler,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    style: valueStyle,
                    readOnly: !_diseaseEnabler,
                    controller: _diseaseController,
                    focusNode: _diseaseNode,
                    cursorColor: kprimaryColor,
                    cursorWidth: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.left,
                    onEditingComplete: () {
                      _diseaseNode.unfocus();
                      _diseaseEnabler = false;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      isCollapsed: true,
                      isDense: true,
                      hintText: 'Add Diseases',
                      hintStyle: TextStyle(
                        fontSize: 11,
                      ),
                      suffix: IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: kprimaryColor,
                            size: 24,
                          ),
                          onPressed: () {
                            if (_diseaseController.text != null &&
                                _diseaseController.text.trim() != '' &&
                                !diseases.contains(_diseaseController.text.trim())) {
                              setState(() {
                                diseases.add(_diseaseController.text.trim());
                              });
                              _diseaseController.clear();
                            }
                          }),
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit, color: kmainHeadingColor1),
                  onPressed: !_showIndicator
                      ? () {
                          setState(() {
                            _diseaseEnabler = true;
                          });
                          _diseaseNode.requestFocus();
                        }
                      : null)
            ],
          ),
          diseases.length != 0
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    children: drawDiseaseColumn(),
                  ),
                )
              : SizedBox.shrink(),
          _showIndicator
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: 65,
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _uploadingTask
                              ? Text('\u2022\u2022\u2022 Uploading Changes \u2022\u2022\u2022', style: kprocessInfoStyle)
                              : Text(' \u2022\u2022\u2022 Saving Data \u2022\u2022\u2022', style: kprocessInfoStyle),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Visibility(
                    visible: isVisible(),
                    child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        _validateAllFields();
                        if (widget.profileImage != null && nameErrorText == null && ageErrorText == null) {
                          setState(() {
                            widget.user.patientName = patientName;
                            widget.user.patientAge = patientAge;
                            widget.user.patientCountry = patientCountry;
                            widget.user.patientCity = patientCity;
                            widget.user.patientDiseaseList = diseases;
                            _showIndicator = true;
                          });
                          await DBHelper().insertPatientDB(widget.user);
                          if (oldProfileImage != widget.profileImage) {
                            await FirebaseStorageHelper().saveImageLocally(userID: widget.user.patientID, image: widget.profileImage);
                          }
                          setState(() {
                            oldProfileImage = widget.profileImage;
                          });
                          bool con = await DataConnectionChecker().hasConnection;
                          if (con) {
                            setState(() {
                              _uploadingTask = true;
                            });
                            await FirestoreHandler().savePatientFirestore(widget.user);
                            await FirebaseStorageHelper().uploadProfileImage(userID: widget.user.patientID, image: widget.profileImage);
                          } else {
                            setState(() {
                              _showIndicator = false;
                            });
                            showDialog(context: context, builder: (_) => showAlert(context: Scaffold.of(context).context));
                          }
                          setState(() {
                            _showIndicator = false;
                          });
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 35,
                        child: Center(
                          child: Text('Update', style: kloginBtn),
                        ),
                        decoration: kGetStartedButton,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
