import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';

// ignore: must_be_immutable
class DoctorProfile extends StatefulWidget {
  DoctorProfile({this.user, this.profileImage});
  dynamic user;
  File profileImage;
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  bool _showIndicator = false;
  bool _uploadingTask = false;
  TextStyle valueStyle = TextStyle(height: 1.5, color: kprimaryColor, fontSize: 19, fontWeight: FontWeight.w500);
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _feeController = TextEditingController();
  TextEditingController _workplaceNameController = TextEditingController();
  TextEditingController _workplaceAddressController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _cityNode = FocusNode();
  FocusNode _feeNode = FocusNode();
  FocusNode _workplaceNameNode = FocusNode();
  FocusNode _workplaceAddressNode = FocusNode();
  String name;
  String phoneNo;
  String doctorCountry;
  String doctorCity;
  String practiceType;
  List<String> specialities = [];
  String doctorExperience;
  String experienceText = 'Work Experience:';
  String doctorFee;
  String workplaceName;
  String workplaceAddress;
  bool _nameEnabler = false;
  bool _phoneEnabler = false;
  bool _cityEnabler = false;
  bool _feeEnabler = false;
  bool _workplaceNameEnabler = false;
  bool _workplaceAddressEnabler = false;
  String nameErrorText;
  String phoneErrorText;
  String cityErrorText;
  String feeErrorText;
  String wpNameErrorText;
  String wpAddressErrorText;
  File oldProfileImage;

  @override
  void initState() {
    oldProfileImage = widget.profileImage;
    name = widget.user.doctorName;
    doctorCountry = widget.user.doctorCountry;
    doctorCity = widget.user.doctorCity;
    phoneNo = PracticeData.countryInfo[doctorCountry][0] == ''
        ? widget.user.doctorPhoneNo.replaceFirst(PracticeData.countryInfo[doctorCountry][0], '')
        : widget.user.doctorPhoneNo.replaceFirst('+' + PracticeData.countryInfo[doctorCountry][0], '');
    practiceType = widget.user.doctorsPracticeType;
    specialities.addAll(widget.user.doctorSpecialtyList);
    doctorExperience = widget.user.doctorsExperience;
    doctorFee = widget.user.doctorsAppointmentFee.split(' ')[0];
    workplaceName = widget.user.doctorsWorkplaceName;
    workplaceAddress = widget.user.doctorsWorkplaceAddress;
    _nameController.text = name;
    _phoneController.text = phoneNo;
    _cityController.text = doctorCity;
    _feeController.text = doctorFee;
    _workplaceNameController.text = workplaceName;
    _workplaceAddressController.text = workplaceAddress;
    super.initState();
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _phoneNode.dispose();
    _workplaceNameNode.dispose();
    _workplaceAddressNode.dispose();
    _cityController.dispose();
    _cityNode.dispose();
    _feeController.dispose();
    _feeNode.dispose();
    _workplaceNameController.dispose();
    _workplaceAddressController.dispose();
    super.dispose();
  }

  bool isVisible() {
    bool visibility = false;
    String phNo = PracticeData.countryInfo[doctorCountry][0] == '' ? phoneNo : '+' + PracticeData.countryInfo[doctorCountry][0] + phoneNo;
    if (oldProfileImage != widget.profileImage ||
        name != widget.user.doctorName ||
        doctorCountry != widget.user.doctorCountry ||
        doctorCity != widget.user.doctorCity ||
        phNo != widget.user.doctorPhoneNo ||
        practiceType != widget.user.doctorsPracticeType ||
        !ListEquality().equals(specialities, widget.user.doctorSpecialtyList) ||
        doctorExperience != widget.user.doctorsExperience ||
        widget.user.doctorsAppointmentFee != doctorFee + ' ' + PracticeData.countryInfo[doctorCountry][1][0] ||
        workplaceName != widget.user.doctorsWorkplaceName ||
        workplaceAddress != widget.user.doctorsWorkplaceAddress) {
      if (widget.profileImage != null && specialities.length != 0) {
        visibility = true;
      }
    }
    return visibility;
  }

  void _validAllFields() {
    if (name == null || name == '') {
      setState(() {
        nameErrorText = 'This is a required field';
      });
    } else if (!RegExp(r'^[a-zA-z.]+([\s][a-zA-Z]+)*$').hasMatch(name)) {
      setState(() {
        nameErrorText = 'This is not a valid name';
      });
    } else {
      setState(() {
        nameErrorText = null;
      });
    }
    if (doctorCity == '' || doctorCity == null) {
      setState(() {
        cityErrorText = 'This is a required field';
      });
    } else {
      setState(() {
        cityErrorText = null;
      });
    }
    if (phoneNo == null || phoneNo == '') {
      setState(() {
        phoneErrorText = 'This field is required';
      });
    } else if (phoneNo.length < 7) {
      setState(() {
        phoneErrorText = 'Phone No. too short. At least 7 digits';
      });
    } else {
      setState(() {
        phoneErrorText = null;
      });
    }
    if (doctorExperience == null) {
      setState(() {
        experienceText = 'Work Experience:';
      });
    } else if (doctorExperience == '') {
      setState(() {
        experienceText = 'This field is required';
      });
    } else if (int.parse(doctorExperience) > 60) {
      setState(() {
        experienceText = 'Experience is too large';
      });
    } else {
      setState(() {
        experienceText = 'Work Experience:';
      });
    }
    if (doctorFee == null || doctorFee == '') {
      setState(() {
        feeErrorText = 'This is a required field';
      });
    } else if (int.parse(doctorFee.split(' ')[0]) > 9000) {
      setState(() {
        feeErrorText = 'Fee cannot be this much';
      });
    } else {
      setState(() {
        feeErrorText = null;
      });
    }
    if (workplaceName == null || workplaceName == '') {
      setState(() {
        wpNameErrorText = 'This is a required field';
      });
    } else {
      setState(() {
        wpNameErrorText = null;
      });
    }
    if (workplaceAddress == null || workplaceAddress == '') {
      setState(() {
        wpAddressErrorText = 'This field is required';
      });
    } else {
      setState(() {
        wpAddressErrorText = null;
      });
    }
  }

  Widget showAlert() {
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

  List<Widget> drawSpecialityColumn() {
    List<Widget> specialitiesWrapList = <Widget>[];
    if (specialities != null) {
      for (String speciality in specialities) {
        specialitiesWrapList.add(Container(
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
                  speciality,
                  style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5, left: 5),
                child: GestureDetector(
                  onTap: !_showIndicator
                      ? () {
                          setState(() {
                            specialities.remove(speciality);
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
    return specialitiesWrapList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.26,
                child: Text(
                  'Name:',
                  style: TextStyle(fontSize: 17, color: nameErrorText == null ? kmainHeadingColor1 : kerrorColor),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  style: valueStyle,
                  readOnly: !_nameEnabler,
                  controller: _nameController,
                  focusNode: _nameNode,
                  cursorColor: kprimaryColor,
                  cursorWidth: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  onChanged: (String value) {
                    name = value;
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
                  padding: EdgeInsets.all(0),
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
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.26,
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
                      selectedItem: doctorCountry,
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
                          doctorCountry = value;
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
                width: MediaQuery.of(context).size.width * 0.26,
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
                    doctorCity = value;
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
                  padding: EdgeInsets.all(0),
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
                width: MediaQuery.of(context).size.width * 0.26,
                child: Text(
                  'Phone No:',
                  style: TextStyle(fontSize: 17, color: phoneErrorText == null ? kmainHeadingColor1 : kerrorColor),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  style: valueStyle,
                  readOnly: !_phoneEnabler,
                  controller: _phoneController,
                  focusNode: _phoneNode,
                  cursorColor: kprimaryColor,
                  cursorWidth: 1,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  onChanged: (String value) {
                    phoneNo = value;
                  },
                  onEditingComplete: () {
                    _phoneNode.unfocus();
                    _phoneEnabler = false;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5),
                    prefix: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        PracticeData.countryInfo[doctorCountry][0] == ''
                            ? PracticeData.countryInfo[doctorCountry][0]
                            : '+' + PracticeData.countryInfo[doctorCountry][0],
                        style: valueStyle,
                      ),
                    ),
                    errorText: phoneErrorText,
                    isCollapsed: true,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.edit, color: phoneErrorText == null ? kmainHeadingColor1 : kerrorColor),
                  onPressed: !_showIndicator
                      ? () {
                          setState(() {
                            _phoneEnabler = true;
                          });
                          _phoneNode.requestFocus();
                        }
                      : null)
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.26,
                  child: Text(
                    'Practice Type:',
                    style: TextStyle(fontSize: 17, color: kmainHeadingColor1),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: AbsorbPointer(
                    absorbing: _showIndicator,
                    child: DropdownSearch(
                      mode: Mode.MENU,
                      items: PracticeData.practiceType,
                      dropDownButton: Icon(
                        Icons.arrow_drop_down,
                        color: kmainHeadingColor1,
                        size: 30,
                      ),
                      selectedItem: practiceType,
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
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              color: kprimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
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
                          if (practiceType != value) {
                            specialities.clear();
                          }
                          practiceType = value;
                        });
                      },
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.26,
                  child: Text(
                    'Specialities:',
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
                      mode: Mode.MENU,
                      items: PracticeData.practiceSubtypes[practiceType],
                      dropDownButton: Icon(
                        Icons.arrow_drop_down,
                        color: kmainHeadingColor1,
                        size: 30,
                      ),
                      selectedItem: '\"${specialities.length} Selected\"',
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
                            style: TextStyle(fontSize: 17, color: Colors.grey),
                          ),
                        );
                      },
                      popupItemBuilder: (context, _doctorPracticeType, isSelected) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Text(_doctorPracticeType,
                              style: TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 15,
                              )),
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          if (!specialities.contains(value)) {
                            specialities.add(value);
                          }
                        });
                      },
                      dropdownSearchDecoration: InputDecoration(
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
          specialities.length != 0
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    children: drawSpecialityColumn(),
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.26,
                  child: Text(
                    'Work Experience: ',
                    style: TextStyle(fontSize: 17, color: kmainHeadingColor1),
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
                                      doctorExperience = (int.parse(doctorExperience) - 1).toString();
                                    });
                                  }
                                : null,
                            child: SizedBox(
                              height: 20,
                              child: Icon(
                                Icons.remove,
                                color: kmainHeadingColor1,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(doctorExperience, style: valueStyle),
                            ],
                          ),
                          GestureDetector(
                            onTap: !_showIndicator
                                ? () {
                                    setState(() {
                                      doctorExperience = (int.parse(doctorExperience) + 1).toString();
                                    });
                                  }
                                : null,
                            child: SizedBox(
                              height: 20,
                              child: Icon(
                                Icons.add,
                                color: kmainHeadingColor1,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.26,
                child: Text(
                  'Appointment fee:',
                  style: TextStyle(fontSize: 17, color: phoneErrorText == null ? kmainHeadingColor1 : kerrorColor),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.34,
                    child: TextField(
                      style: valueStyle,
                      readOnly: !_feeEnabler,
                      controller: _feeController,
                      focusNode: _feeNode,
                      cursorColor: kprimaryColor,
                      cursorWidth: 1,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.left,
                      onChanged: (String value) {
                        doctorFee = value;
                      },
                      onEditingComplete: () {
                        _feeNode.unfocus();
                        _feeEnabler = false;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 25),
                        suffix: Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: Text(
                            PracticeData.countryInfo[doctorCountry][1].length != 0 ? PracticeData.countryInfo[doctorCountry][1][0] : '',
                            style: valueStyle,
                          ),
                        ),
                        errorText: feeErrorText,
                        isCollapsed: true,
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.edit, color: feeErrorText == null ? kmainHeadingColor1 : kerrorColor),
                      onPressed: !_showIndicator
                          ? () {
                              setState(() {
                                _feeEnabler = true;
                              });
                              _feeNode.requestFocus();
                            }
                          : null)
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.26,
                child: Text(
                  'Workplace Name:',
                  style: TextStyle(fontSize: 17, color: wpNameErrorText == null ? kmainHeadingColor1 : kerrorColor),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  style: valueStyle,
                  readOnly: !_workplaceNameEnabler,
                  controller: _workplaceNameController,
                  focusNode: _workplaceNameNode,
                  cursorColor: kprimaryColor,
                  cursorWidth: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  onChanged: (String value) {
                    workplaceName = value;
                  },
                  onEditingComplete: () {
                    _workplaceNameNode.unfocus();
                    _workplaceNameEnabler = false;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5),
                    errorText: wpNameErrorText,
                    isCollapsed: true,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.edit, color: wpNameErrorText == null ? kmainHeadingColor1 : kerrorColor),
                  onPressed: !_showIndicator
                      ? () {
                          setState(() {
                            _workplaceNameEnabler = true;
                          });
                          _workplaceNameNode.requestFocus();
                        }
                      : null)
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.26,
                child: Text(
                  'Workplace Address:',
                  style: TextStyle(fontSize: 17, color: wpAddressErrorText == null ? kmainHeadingColor1 : kerrorColor),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  style: valueStyle,
                  readOnly: !_workplaceAddressEnabler,
                  controller: _workplaceAddressController,
                  focusNode: _workplaceAddressNode,
                  cursorColor: kprimaryColor,
                  cursorWidth: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  onChanged: (String value) {
                    workplaceAddress = value;
                  },
                  onEditingComplete: () {
                    _workplaceAddressNode.unfocus();
                    _workplaceAddressEnabler = false;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5),
                    errorText: wpAddressErrorText,
                    isCollapsed: true,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.edit, color: wpAddressErrorText == null ? kmainHeadingColor1 : kerrorColor),
                  onPressed: !_showIndicator
                      ? () {
                          setState(() {
                            _workplaceAddressEnabler = true;
                          });
                          _workplaceAddressNode.requestFocus();
                        }
                      : null)
            ],
          ),
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
                        _validAllFields();
                        if (widget.profileImage != null &&
                            nameErrorText == null &&
                            cityErrorText == null &&
                            phoneErrorText == null &&
                            experienceText == 'Work Experience:' &&
                            feeErrorText == null &&
                            wpNameErrorText == null &&
                            wpAddressErrorText == null) {
                          setState(() {
                            widget.user.doctorName = name;
                            widget.user.doctorCountry = doctorCountry;
                            widget.user.doctorCity = doctorCity;
                            widget.user.doctorPhoneNo = PracticeData.countryInfo[doctorCountry][0].length != 0
                                ? '+' + PracticeData.countryInfo[doctorCountry][0] + phoneNo
                                : '' + phoneNo;
                            widget.user.doctorsPracticeType = practiceType;
                            widget.user.doctorSpecialtyList = specialities;
                            widget.user.doctorsExperience = doctorExperience;
                            widget.user.doctorsAppointmentFee = PracticeData.countryInfo[doctorCountry][1].length != 0
                                ? doctorFee + ' ' + PracticeData.countryInfo[doctorCountry][1][0]
                                : doctorFee;
                            widget.user.doctorsWorkplaceName = workplaceName;
                            widget.user.doctorsWorkplaceAddress = workplaceAddress;
                            _showIndicator = true;
                          });
                          await DBHelper().insertDoctorDB(widget.user);
                          if (oldProfileImage != widget.profileImage) {
                            await FirebaseStorageHelper().saveImageLocally(userID: widget.user.doctorID, image: widget.profileImage);
                          }
                          setState(() {
                            oldProfileImage = widget.profileImage;
                          });
                          bool con = await DataConnectionChecker().hasConnection;
                          if (con) {
                            setState(() {
                              _uploadingTask = true;
                            });
                            await FirestoreHandler().saveDoctorFirestore(widget.user);
                            await FirebaseStorageHelper().uploadProfileImage(userID: widget.user.doctorID, image: widget.profileImage);
                          } else {
                            setState(() {
                              _showIndicator = false;
                            });
                            showDialog(context: context, builder: (_) => showAlert());
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
                )
        ],
      ),
    );
  }
}
