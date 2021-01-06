import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/screens/home_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/custom_text_field.dart';

class DoctorForm extends StatefulWidget {
  DoctorForm({this.userId, this.profileImage});

  final String userId;
  final File profileImage;

  @override
  _DoctorFormState createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
  String _doctorName;
  String _dNameError;
  String _doctorPhoneNo;
  String _dphoneError;
  String _doctorPracticeType;
  String _doctorCountry;
  String _doctorCity;
  String _cityErrorText;
  String _doctorExperience;
  String _experienceText = 'Enter your work experience in years';
  String _workplaceName;
  String _workplaceNameErrorText;
  String _workplaceAddress;
  String _workplaceAddressErrorText;
  String _dialingCode = '';
  String _currencyCode = '';
  String _feeText = 'Appointment Fee:';
  String _doctorAppointmentFee;
  List<String> _doctorSpecialitiesList = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _workplaceNameNode = FocusNode();
  FocusNode _workplaceAddressNode = FocusNode();
  FocusNode _feeNode = FocusNode();
  DBHelper _dbHelper = DBHelper();
  Doctor _doctor;
  bool _showIndicator = false;
  bool _uploadTask = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameNode.dispose();
    _phoneNode.dispose();
    _workplaceNameNode.dispose();
    _workplaceAddressNode.dispose();
    _feeNode.dispose();
    super.dispose();
  }

  List<Widget> drawSpecialityColumn() {
    List<Widget> specialitiesWrapList = <Widget>[];
    if (_doctorSpecialitiesList != null) {
      for (String speciality in _doctorSpecialitiesList) {
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
                  onTap: () {
                    setState(() {
                      _doctorSpecialitiesList.remove(speciality);
                    });
                  },
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

  void _validAllFields() {
    if (_doctorName == null || _doctorName == '') {
      setState(() {
        _dNameError = 'This is a required field';
      });
    } else if (!RegExp(r'^[a-zA-z.]+([\s][a-zA-Z]+)*$').hasMatch(_doctorName)) {
      setState(() {
        _dNameError = 'This is not a valid name';
      });
    } else {
      setState(() {
        _dNameError = null;
      });
    }
    if (_doctorPhoneNo == null || _doctorPhoneNo == '') {
      setState(() {
        _dphoneError = 'This field is required';
      });
    } else if (_doctorPhoneNo.length < 7) {
      setState(() {
        _dphoneError = 'Phone No. too short';
      });
    } else {
      setState(() {
        _dphoneError = null;
      });
    }
    if (_doctorCity == '' || _doctorCity == null) {
      setState(() {
        _cityErrorText = 'This is a required field';
      });
    } else {
      setState(() {
        _cityErrorText = null;
      });
    }
    if (_doctorExperience == null) {
      setState(() {
        _experienceText = 'Enter your work experience in years';
      });
    } else if (_doctorExperience == '') {
      setState(() {
        _experienceText = 'This field is required';
      });
    } else if (int.parse(_doctorExperience) > 60) {
      setState(() {
        _experienceText = 'Experience is too large';
      });
    } else {
      setState(() {
        _experienceText = 'Enter your work experience in years';
      });
    }
    if (_doctorAppointmentFee == null) {
      setState(() {
        _feeText = 'Appointment Fee:';
      });
    } else if (_doctorAppointmentFee == '') {
      setState(() {
        _feeText = 'This is a required field';
      });
    } else if (int.parse(_doctorAppointmentFee) > 9000) {
      setState(() {
        _feeText = 'Fee cannot be this much';
      });
    } else {
      setState(() {
        _feeText = 'Appointment Fee:';
      });
    }
    if (_workplaceName == null || _workplaceName == '') {
      setState(() {
        _workplaceNameErrorText = 'This is a required field';
      });
    } else {
      setState(() {
        _workplaceNameErrorText = null;
      });
    }
    if (_workplaceAddress == null || _workplaceAddress == '') {
      setState(() {
        _workplaceAddressErrorText = 'This field is required';
      });
    } else {
      setState(() {
        _workplaceAddressErrorText = null;
      });
    }
  }

  Widget showAlert({String alertMessage}) {
    return AlertDialog(
      title: Text('Alert !', style: kdialogTitleStyle),
      content: Text(alertMessage, style: kalertDescriptionStyle),
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
          onTap: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => HomeScreen(user: _doctor)));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Wrap(
              children: <Widget>[
                Text(
                  'Basic Info.',
                  style: TextStyle(fontSize: 19, color: kmainHeadingColor1, fontWeight: FontWeight.w600),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.grey,
                  endIndent: 10,
                  indent: 80,
                ),
              ],
            ),
          ),
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.103,
            width: MediaQuery.of(context).size.width * 0.84,
            textController: _nameController,
            node: _nameNode,
            readOnly: _showIndicator,
            contentPadding: EdgeInsets.only(left: 25),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: false,
            onChanged: (String value) {
              setState(() {
                _doctorName = value.trim();
              });
            },
            onEditingComplete: () {
              _nameNode.unfocus();
            },
            onFieldSubmitted: (String name) {
              if (_doctorName == null || _doctorName == '') {
                setState(() {
                  _dNameError = 'This is a required field';
                });
              } else if (!RegExp(r'^[a-zA-z.]+([\s][a-zA-Z]+)*$').hasMatch(_doctorName)) {
                setState(() {
                  _dNameError = 'This is not a valid name';
                });
              } else {
                setState(() {
                  _dNameError = null;
                });
              }
            },
            errorText: _dNameError,
            suffix: null,
            labelText: 'Name',
            helperText: 'Enter your full name',
            hintText: null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AbsorbPointer(
                absorbing: _showIndicator,
                child: Container(
                  height: 60, //MediaQuery.of(context).size.height * 0.093,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: ksmallFieldDecoration,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: DropdownSearch(
                      popupBackgroundColor: Color(0xffF6FDF6),
                      mode: Mode.DIALOG,
                      items: PracticeData.countryInfo.keys.toList(),
                      dropDownButton: Icon(
                        Icons.arrow_drop_down,
                        color: kheadingColor2,
                        size: 30,
                      ),
                      showSearchBox: true,
                      selectedItem: _doctorCountry == null ? null : _doctorCountry,
                      popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: kprimaryColor,
                          )),
                      dropdownBuilder: _doctorCountry == null
                          ? null
                          : (context, _doctorPracticeType, String value) {
                              return Padding(
                                padding: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    color: kprimaryColor,
                                    fontSize: 18,
                                    height: 1,
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
                                color: kheadingColor2,
                                fontSize: 15,
                                height: 1.2,
                              )),
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          _doctorCountry = value;
                          _dialingCode = PracticeData.countryInfo[_doctorCountry][0];
                          _currencyCode =
                              PracticeData.countryInfo[_doctorCountry][1].length != 0 ? PracticeData.countryInfo[_doctorCountry][1][0] : '';
                        });
                      },
                      searchBoxDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        fillColor: Color(0xffF6FDF6),
                        filled: true,
                        labelText: 'Country',
                        labelStyle: TextStyle(
                            color: kheadingColor2, //Color(0x7055D24A),
                            fontSize: 15,
                            height: 1.2),
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
                        contentPadding: EdgeInsets.only(left: 10),
                        fillColor: Color(0xffF6FDF6),
                        filled: true,
                        labelText: 'Country',
                        labelStyle: TextStyle(
                            color: kheadingColor2, //Color(0x7055D24A),
                            fontSize: 15,
                            height: 1.2),
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
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: _cityErrorText == null
                        ? [
                            BoxShadow(
                              color: kmainHeadingColor1.withAlpha(120),
                              offset: Offset(0, -2),
                              blurRadius: 10,
                              spreadRadius: -18,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: kmainHeadingColor1.withAlpha(120),
                              offset: Offset(0, -2),
                              blurRadius: 8,
                              spreadRadius: -26,
                            ),
                          ]),
                child: CustomTextFields(
                  height: 60, //MediaQuery.of(context).size.height * 0.093,
                  width: MediaQuery.of(context).size.width * 0.45,
                  contentPadding: EdgeInsets.only(left: 25),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  readOnly: _showIndicator,
                  node: null,
                  textController: null,
                  obscureText: false,
                  onChanged: (String value) {
                    setState(() {
                      _doctorCity = value.trim();
                    });
                  },
                  onEditingComplete: () {
                    _phoneNode.requestFocus();
                  },
                  onFieldSubmitted: (String value) {
                    if (_doctorCity == '' || _doctorCity == null) {
                      setState(() {
                        _cityErrorText = 'This is a required field';
                      });
                    } else {
                      setState(() {
                        _cityErrorText = null;
                      });
                    }
                  },
                  helperText: null,
                  errorText: _cityErrorText,
                  suffix: null,
                  labelText: 'City',
                  hintText: null,
                ),
              ),
            ],
          ),
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.103,
            width: MediaQuery.of(context).size.width * 0.84,
            textController: _phoneController,
            node: _phoneNode,
            readOnly: _showIndicator,
            contentPadding: EdgeInsets.only(left: 15),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            obscureText: false,
            onChanged: (String value) {
              setState(() {
                _doctorPhoneNo = value;
              });
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            onFieldSubmitted: (String value) {
              if (_doctorPhoneNo == null || _doctorPhoneNo == '') {
                setState(() {
                  _dphoneError = 'This field is required';
                });
              } else if (_doctorPhoneNo.length < 7) {
                setState(() {
                  _dphoneError = 'Phone No. too short';
                });
              } else {
                setState(() {
                  _dphoneError = null;
                });
              }
            },
            errorText: _dphoneError,
            suffix: null,
            prefix: Padding(
              padding: EdgeInsets.only(right: 15),
              child: Text(_dialingCode == '' ? _dialingCode : '+$_dialingCode',
                  style: TextStyle(
                    height: 1.5,
                    color: _dphoneError == null ? kprimaryColor : kerrorColor,
                    fontSize: 20,
                  )),
            ),
            labelText: 'Phone No.',
            helperText: 'Provide a valid number where users can reach you',
            hintText: null,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: <Widget>[
                Text(
                  'Professional Info.',
                  style: TextStyle(fontSize: 19, color: kmainHeadingColor1, fontWeight: FontWeight.w600),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.grey,
                  endIndent: 10,
                  indent: 133,
                ),
              ],
            ),
          ),
          AbsorbPointer(
            absorbing: _showIndicator,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 65, //MediaQuery.of(context).size.height * 0.100,
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: ktextFieldDecoration,
              child: DropdownSearch(
                popupBackgroundColor: Color(0xffF6FDF6),
                mode: Mode.MENU,
                items: PracticeData.practiceType,
                maxHeight: 80,
                dropDownButton: Icon(
                  Icons.arrow_drop_down,
                  color: kheadingColor2,
                  size: 30,
                ),
                selectedItem: _doctorPracticeType == null ? null : _doctorPracticeType,
                popupShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: kprimaryColor,
                    )),
                dropdownBuilder: _doctorPracticeType == null
                    ? null
                    : (context, _doctorPracticeType, String value) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(value,
                              style: TextStyle(
                                fontFamily: 'Comfortaa',
                                color: kprimaryColor,
                                fontSize: 18,
                                height: 1,
                              )),
                        );
                      },
                popupItemBuilder: (context, _doctorPracticeType, iselected) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15, top: 20),
                    child: Text(_doctorPracticeType,
                        style: TextStyle(
                          fontFamily: 'Comfortaa',
                          color: kheadingColor2,
                          fontSize: 15,
                          height: 1,
                        )),
                  );
                },
                onChanged: (value) {
                  setState(() {
                    if (_doctorPracticeType != value) {
                      _doctorSpecialitiesList.clear();
                    }
                    _doctorPracticeType = value;
                  });
                },
                dropdownSearchDecoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  helperText: 'Please select your practice type',
                  helperStyle: TextStyle(fontSize: 10, color: kheadingColor2),
                  fillColor: Color(0xffF6FDF6),
                  filled: true,
                  labelText: 'Practice Type',
                  labelStyle: TextStyle(
                      color: kheadingColor2, //Color(0x7055D24A),
                      fontSize: 15,
                      height: 1.2),
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
              ),
            ),
          ),
          Visibility(
            visible: _doctorPracticeType == null || _doctorPracticeType == '' ? false : true,
            child: AbsorbPointer(
              absorbing: _showIndicator,
              child: Container(
                height: 65, //MediaQuery.of(context).size.height * 0.100,
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: ktextFieldDecoration,
                child: DropdownSearch(
                  popupBackgroundColor: Color(0xffF6FDF6),
                  mode: Mode.MENU,
                  items: PracticeData.practiceSubtypes[_doctorPracticeType],
                  dropDownButton: Icon(
                    Icons.arrow_drop_down,
                    color: kheadingColor2,
                    size: 30,
                  ),
                  selectedItem: 'Specialities',
                  popupShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: kprimaryColor,
                      )),
                  dropdownBuilder: (context, _doctorPracticeType, String value) {
                    return Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Text(value,
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            color: kprimaryColor,
                            fontSize: 18,
                            height: 1,
                          )),
                    );
                  },
                  popupItemBuilder: (context, _doctorPracticeType, iselected) {
                    return Padding(
                      padding: EdgeInsets.only(left: 25, top: 20, bottom: 10),
                      child: Text(_doctorPracticeType,
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            color: kheadingColor2,
                            fontSize: 15,
                            height: 1,
                          )),
                    );
                  },
                  onChanged: (value) {
                    setState(() {
                      if (!_doctorSpecialitiesList.contains(value)) {
                        _doctorSpecialitiesList.add(value);
                      }
                    });
                  },
                  dropdownSearchDecoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    helperText: 'You can select more than one speciality',
                    helperStyle: TextStyle(fontSize: 10, color: kheadingColor2),
                    fillColor: Color(0xffF6FDF6),
                    filled: true,
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
                ),
              ),
            ),
          ),
          _doctorSpecialitiesList.length != 0
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Wrap(
                    children: drawSpecialityColumn(),
                  ),
                )
              : SizedBox.shrink(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Text(
                  _experienceText,
                  style: _experienceText == 'Enter your work experience in years'
                      ? TextStyle(color: kheadingColor2, fontSize: 15)
                      : TextStyle(color: kerrorColor, fontSize: 15),
                ),
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: kmainHeadingColor1.withAlpha(120),
                    offset: Offset(0, 0),
                    blurRadius: 7,
                    spreadRadius: -10,
                  ),
                ]),
                child: CustomTextFields(
                  width: MediaQuery.of(context).size.width * 0.175,
                  height: 50, //MediaQuery.of(context).size.height * 0.078,
                  contentPadding: EdgeInsets.only(bottom: 3),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  readOnly: _showIndicator,
                  node: null,
                  textController: null,
                  obscureText: false,
                  onChanged: (String value) {
                    setState(() {
                      _doctorExperience = value;
                    });
                    if (_experienceText != null) {
                      if (_doctorExperience == null) {
                        setState(() {
                          _experienceText = 'Enter your work experience in years';
                        });
                      } else if (_doctorExperience == '') {
                        setState(() {
                          _experienceText = 'This field is required';
                        });
                      } else if (int.parse(_doctorExperience) > 60) {
                        setState(() {
                          _experienceText = 'Experience is too large';
                        });
                      } else {
                        setState(() {
                          _experienceText = 'Enter your work experience in years';
                        });
                      }
                    }
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_feeNode);
                  },
                  onFieldSubmitted: (String value) {
                    if (_doctorExperience == null) {
                      setState(() {
                        _experienceText = 'Enter your work experience in years';
                      });
                    } else if (_doctorExperience == '') {
                      setState(() {
                        _experienceText = 'This field is required';
                      });
                    } else if (int.parse(_doctorExperience) > 60) {
                      setState(() {
                        _experienceText = 'Experience is too large';
                      });
                    } else {
                      setState(() {
                        _experienceText = 'Enter your work experience in years';
                      });
                    }
                  },
                  errorText: null,
                  suffix: null,
                  labelText: null,
                  helperText: null,
                  hintText: null,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  _feeText,
                  style:
                      _feeText == 'Appointment Fee:' ? TextStyle(color: kheadingColor2, fontSize: 15) : TextStyle(color: kerrorColor, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: kmainHeadingColor1.withAlpha(120),
                    offset: Offset(0, 0),
                    blurRadius: 7,
                    spreadRadius: -10,
                  ),
                ]),
                child: CustomTextFields(
                  height: 50, //MediaQuery.of(context).size.height * 0.078,
                  width: MediaQuery.of(context).size.width * 0.40,
                  contentPadding: EdgeInsets.only(right: 13),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  readOnly: _showIndicator,
                  node: _feeNode,
                  textAlign: TextAlign.center,
                  textController: null,
                  obscureText: false,
                  onChanged: (String value) {
                    setState(() {
                      _doctorAppointmentFee = value;
                    });
                    if (_feeText != null) {
                      if (_doctorAppointmentFee == null) {
                        setState(() {
                          _feeText = 'Appointment Fee:';
                        });
                      } else if (_doctorAppointmentFee == '') {
                        setState(() {
                          _feeText = 'This is a required field';
                        });
                      } else if (int.parse(_doctorAppointmentFee) > 9000) {
                        setState(() {
                          _feeText = 'Fee cannot be this much';
                        });
                      } else {
                        setState(() {
                          _feeText = 'Appointment Fee:';
                        });
                      }
                    }
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_workplaceNameNode);
                  },
                  onFieldSubmitted: (String value) {
                    if (_feeText != null) {
                      if (_doctorAppointmentFee == null) {
                        setState(() {
                          _feeText = 'Appointment Fee:';
                        });
                      } else if (_doctorAppointmentFee == '') {
                        setState(() {
                          _feeText = 'This is a required field';
                        });
                      } else if (int.parse(_doctorAppointmentFee) > 9000) {
                        setState(() {
                          _feeText = 'Fee cannot be this much';
                        });
                      } else {
                        setState(() {
                          _feeText = 'Appointment Fee:';
                        });
                      }
                    }
                  },
                  errorText: null,
                  suffix: Text(_currencyCode,
                      style: TextStyle(
                        height: 1.5,
                        color: _feeText == 'Appointment Fee:' ? kprimaryColor : kerrorColor,
                        fontSize: 18,
                      )),
                  labelText: null,
                  helperText: null,
                  hintText: null,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.100,
            width: MediaQuery.of(context).size.width * 0.80,
            textController: null,
            node: _workplaceNameNode,
            readOnly: _showIndicator,
            contentPadding: EdgeInsets.only(left: 25, right: 15),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: false,
            onChanged: (String value) {
              setState(() {
                _workplaceName = value.trim();
              });
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_workplaceAddressNode);
            },
            onFieldSubmitted: (String name) {
              if (_workplaceName == null || _workplaceName == '') {
                setState(() {
                  _workplaceNameErrorText = 'This is a required field';
                });
              } else {
                setState(() {
                  _workplaceNameErrorText = null;
                });
              }
            },
            errorText: _workplaceNameErrorText,
            suffix: null,
            labelText: 'Workplace Name',
            helperText: 'Enter the name of your Workplace (e.g. Hospital/Clinic)',
            hintText: null,
          ),
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.100,
            width: MediaQuery.of(context).size.width * 0.80,
            textController: null,
            node: _workplaceAddressNode,
            readOnly: _showIndicator,
            contentPadding: EdgeInsets.only(left: 25, right: 15),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: false,
            onChanged: (String value) {
              setState(() {
                _workplaceAddress = value.trim();
              });
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            onFieldSubmitted: (String value) {
              if (_workplaceAddress == null || _workplaceAddress == '') {
                setState(() {
                  _workplaceAddressErrorText = 'This field is required';
                });
              } else {
                setState(() {
                  _workplaceAddressErrorText = null;
                });
              }
            },
            errorText: _workplaceAddressErrorText,
            suffix: null,
            labelText: 'Workplace Address',
            helperText: 'Enter the address of your workplace',
            hintText: null,
          ),
          Visibility(
            visible: _doctorName != null &&
                    _doctorPhoneNo != null &&
                    _doctorCountry != null &&
                    _doctorCity != null &&
                    _doctorPracticeType != null &&
                    _doctorSpecialitiesList.isNotEmpty &&
                    _doctorExperience != null &&
                    _workplaceName != null &&
                    _doctorAppointmentFee != null &&
                    _workplaceAddress != null &&
                    widget.profileImage != null
                ? true
                : false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                _showIndicator
                    ? SizedBox(
                        height: 65,
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _uploadTask
                                  ? Text('\u2022\u2022\u2022 Uploading Profile \u2022\u2022\u2022', style: kprocessInfoStyle)
                                  : Text('\u2022\u2022\u2022 Saving Data \u2022\u2022\u2022', style: kprocessInfoStyle),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15),
                        child: GestureDetector(
                          onTap: () async {
                            _validAllFields();
                            if (_dNameError == null &&
                                _dphoneError == null &&
                                _cityErrorText == null &&
                                _experienceText == 'Enter your work experience in years' &&
                                _feeText == 'Appointment Fee:' &&
                                _doctorExperience != null &&
                                _workplaceNameErrorText == null &&
                                _workplaceAddressErrorText == null) {
                              setState(() {
                                _showIndicator = true;
                                _doctor = Doctor(
                                    doctorID: widget.userId,
                                    doctorName: _doctorName,
                                    doctorPhoneNo: _dialingCode == '' ? _doctorPhoneNo : '+$_dialingCode$_doctorPhoneNo',
                                    doctorCountry: _doctorCountry,
                                    doctorCity: _doctorCity,
                                    doctorsPracticeType: _doctorPracticeType,
                                    doctorSpecialtyList: _doctorSpecialitiesList,
                                    doctorsExperience: _doctorExperience,
                                    doctorsAppointmentFee: '$_doctorAppointmentFee $_currencyCode',
                                    doctorsPatientList: [],
                                    doctorsWorkplaceName: _workplaceName,
                                    doctorsWorkplaceAddress: _workplaceAddress);
                              });
                              await _dbHelper.insertDoctorDB(_doctor);
                              await FirebaseStorageHelper().saveImageLocally(userID: widget.userId, image: widget.profileImage);
                              bool isInternetAvailable = await DataConnectionChecker().hasConnection;
                              if (!isInternetAvailable) {
                                showDialog(
                                    context: context,
                                    builder: (_) => showAlert(
                                        alertMessage:
                                            'Your are not connected to Internet. Your Details and Profile Image will not be saved in cloud. Once you connect to Internet they will be saved automatically.'));
                                setState(() {
                                  _showIndicator = false;
                                });
                              } else {
                                setState(() {
                                  _uploadTask = true;
                                });
                                await _firestoreHandler.saveDoctorFirestore(_doctor);
                                await FirebaseStorageHelper().uploadProfileImage(userID: widget.userId, image: widget.profileImage);
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (context) => HomeScreen(
                                      user: _doctor,
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                _showIndicator = false;
                                _uploadTask = false;
                              });
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Center(child: Text('Next', style: kloginBtn)),
                                  flex: 2,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            decoration: kGetStartedButton,
                          ),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
