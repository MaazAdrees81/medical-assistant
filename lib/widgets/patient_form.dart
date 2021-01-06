import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/home_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/custom_text_field.dart';

class PatientForm extends StatefulWidget {
  PatientForm({this.userId, this.profileImage});

  final String userId;
  final File profileImage;

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
  DBHelper _dbHelper = DBHelper();
  String _patientName;
  String _pNameError;
  String _patientAge;
  String _ageText = 'Enter your age:';
  String _patientCountry;
  String _patientCity;
  String _pcityErrorText;
  List<String> _patientDiseaseList = List();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  FocusNode _ageNode = FocusNode();
  FocusNode _diseaseNode = FocusNode();
  Patient _patient;
  bool _showIndicator = false;
  bool _uploadTask = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _diseaseController.dispose();
    _nameNode.dispose();
    _ageNode.dispose();
    _diseaseNode.dispose();
    super.dispose();
  }

  List<Widget> drawDiseaseColumn() {
    List<Widget> diseaseColumnList = <Widget>[];
    if (_patientDiseaseList.length != 0) {
      for (String disease in _patientDiseaseList) {
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
                  onTap: () {
                    setState(() {
                      _patientDiseaseList.remove(disease);
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
    return diseaseColumnList;
  }

  void _validateAllFields() {
    if (_patientName == null || _patientName == '') {
      setState(() {
        _pNameError = 'This is a required field';
      });
    } else if (!RegExp(r'^[a-zA-z.]+([\s][a-zA-Z]+)*$').hasMatch(_patientName)) {
      setState(() {
        _pNameError = 'This is not a valid name';
      });
    } else {
      setState(() {
        _pNameError = null;
      });
    }
    if (_patientAge == null) {
      setState(() {
        _ageText = 'Enter your age:';
      });
    } else if (_patientAge == '') {
      setState(() {
        _ageText = 'This field is required';
      });
    } else if (int.parse(_patientAge) >= 100) {
      setState(() {
        _ageText = 'Age is too large';
      });
    } else if (int.parse(_patientAge) <= 14) {
      setState(() {
        _ageText = 'Age is too small';
      });
    } else {
      setState(() {
        _ageText = 'Enter your age:';
      });
    }
    if (_patientCity == '' || _patientCity == null) {
      setState(() {
        _pcityErrorText = 'This is a required field';
      });
    } else {
      setState(() {
        _pcityErrorText = null;
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
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => HomeScreen(user: _patient)));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            height: 65, //MediaQuery.of(context).size.height * 0.100, //65
            width: MediaQuery.of(context).size.width * 0.80,
            textController: _nameController,
            node: _nameNode,
            readOnly: _showIndicator,
            contentPadding: EdgeInsets.only(left: 25),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: false,
            onChanged: (String value) {
              setState(() {
                _patientName = value.trim();
              });
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_ageNode);
            },
            onFieldSubmitted: (String name) {
              if (_patientName == null || _patientName == '') {
                setState(() {
                  _pNameError = 'This is a required field';
                });
              } else if (!RegExp(r'^[a-zA-z.]+([\s][a-zA-Z]+)*$').hasMatch(_patientName)) {
                setState(() {
                  _pNameError = 'This is not a valid name';
                });
              } else {
                setState(() {
                  _pNameError = null;
                });
              }
            },
            errorText: _pNameError,
            suffix: null,
            labelText: 'Name',
            helperText: 'Enter your full name',
            hintText: null,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width * 0.80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Text(
                    _ageText,
                    style: _ageText == 'Enter your age:'
                        ? TextStyle(color: kheadingColor2, fontSize: 17)
                        : TextStyle(color: Color(0xfff75010), fontSize: 17),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: kmainHeadingColor1.withAlpha(120),
                      offset: Offset(0, -2),
                      blurRadius: 7,
                      spreadRadius: -9,
                    ),
                  ]),
                  child: CustomTextFields(
                    width: MediaQuery.of(context).size.width * 0.175,
                    height: 50, //MediaQuery.of(context).size.height * 0.07,
                    textController: _ageController,
                    node: _ageNode,
                    readOnly: _showIndicator,
                    contentPadding: EdgeInsets.only(bottom: 3),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    obscureText: false,
                    onChanged: (String value) {
                      setState(() {
                        _patientAge = value;
                      });
                      if (_ageText != 'Enter your age:') {
                        if (_patientAge == null) {
                          setState(() {
                            _ageText = 'Enter your age:';
                          });
                        } else if (_patientAge == '') {
                          setState(() {
                            _ageText = 'This field is required';
                          });
                        } else if (int.parse(_patientAge) >= 100) {
                          setState(() {
                            _ageText = 'Age is too large';
                          });
                        } else if (int.parse(_patientAge) <= 14) {
                          setState(() {
                            _ageText = 'Age is too small';
                          });
                        } else {
                          setState(() {
                            _ageText = 'Enter your age:';
                          });
                        }
                      }
                    },
                    onEditingComplete: () {
                      _ageNode.unfocus();
                    },
                    onFieldSubmitted: (String value) {
                      if (_patientAge == null) {
                        setState(() {
                          _ageText = 'Enter your age:';
                        });
                      } else if (_patientAge == '') {
                        setState(() {
                          _ageText = 'This field is required';
                        });
                      } else if (int.parse(_patientAge) >= 100) {
                        setState(() {
                          _ageText = 'Age is too large';
                        });
                      } else if (int.parse(_patientAge) <= 14) {
                        setState(() {
                          _ageText = 'Age is too small';
                        });
                      } else {
                        setState(() {
                          _ageText = 'Enter your age:';
                        });
                      }
                    },
                    errorText: null,
                    suffix: null,
                    labelText: null,
                    helperText: null,
                    hintText: null,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      selectedItem: _patientCountry == null ? null : _patientCountry,
                      popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: kprimaryColor,
                          )),
                      dropdownBuilder: _patientCountry == null
                          ? null
                          : (context, _doctorPracticeType, String value) {
                              return Padding(
                                padding: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    color: kprimaryColor,
                                    fontSize: 16,
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
                          _patientCountry = value;
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
                    boxShadow: _pcityErrorText == null
                        ? [
                            BoxShadow(
                              color: kmainHeadingColor1.withAlpha(120),
                              offset: Offset(0, -2),
                              blurRadius: 7,
                              spreadRadius: -18,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: kerrorColor.withAlpha(120),
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
                      _patientCity = value.trim();
                    });
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_diseaseNode);
                  },
                  onFieldSubmitted: (String value) {
                    if (_patientCity == '' || _patientCity == null) {
                      setState(() {
                        _pcityErrorText = 'This is a required field';
                      });
                    } else {
                      setState(() {
                        _pcityErrorText = null;
                      });
                    }
                  },
                  helperText: null,
                  errorText: _pcityErrorText,
                  suffix: null,
                  labelText: 'City',
                  hintText: null,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: <Widget>[
                Text(
                  'Medical Conditions.',
                  style: TextStyle(fontSize: 19, color: kmainHeadingColor1, fontWeight: FontWeight.w600),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.grey,
                  endIndent: 10,
                  indent: 155,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Text(
              'Enter any Medical Condition or a Disease that you have, for which you are searching for a Specialist. Please try to use the correct Medical Term to explain your Disease. (you can add more than one disease)',
              style: TextStyle(height: 1.3, color: Colors.blueGrey),
            ),
          ),
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.100,
            width: MediaQuery.of(context).size.width * 0.80,
            textController: _diseaseController,
            node: _diseaseNode,
            readOnly: _showIndicator,
            contentPadding: EdgeInsets.only(left: 25, bottom: 25),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: false,
            isDense: true,
            onChanged: null,
            onEditingComplete: () {
              _diseaseNode.unfocus();
            },
            onFieldSubmitted: null,
            errorText: null,
            suffix: IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: kprimaryColor,
                  size: 24,
                ),
                onPressed: () {
                  if (_diseaseController.text != null &&
                      _diseaseController.text.trim() != '' &&
                      !_patientDiseaseList.contains(_diseaseController.text.trim())) {
                    setState(() {
                      _patientDiseaseList.add(_diseaseController.text.trim());
                    });
                  }
                  _diseaseController.clear();
                }),
            labelText: 'Disease',
            hintText: null,
            helperText: 'This is an optional field you can skip it if you want',
          ),
          _patientDiseaseList.length != 0
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.22,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: drawDiseaseColumn(),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Visibility(
            visible: _ageText == 'Enter your age:' &&
                    _pNameError == null &&
                    _patientName != null &&
                    _patientName != '' &&
                    _patientAge != null &&
                    _patientAge != '' &&
                    _patientCountry != '' &&
                    _patientCountry != null &&
                    _patientCity != null &&
                    _patientCity != '' &&
                    widget.profileImage != null
                ? true
                : false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                _showIndicator
                    ? Column(
                        children: <Widget>[
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: _uploadTask
                                ? Text('\u2022\u2022\u2022 Uploading Profile \u2022\u2022\u2022', style: kprocessInfoStyle)
                                : Text(' \u2022\u2022\u2022 Saving Data \u2022\u2022\u2022', style: kprocessInfoStyle),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () async {
                          _validateAllFields();
                          if (_ageText == 'Enter your age:' &&
                              _pNameError == null &&
                              _patientName != null &&
                              _patientName != '' &&
                              _patientAge != null &&
                              _patientAge != '' &&
                              _patientCity != '' &&
                              _patientCity != null &&
                              _pcityErrorText == null &&
                              _patientCountry != null &&
                              _patientCountry != '') {
                            setState(() {
                              _showIndicator = true;
                              _patient = Patient(
                                  patientID: widget.userId,
                                  patientName: _patientName,
                                  patientAge: _patientAge,
                                  patientAppointments: [],
                                  patientsAlarms: [],
                                  patientsDoctorList: [],
                                  patientCountry: _patientCountry,
                                  patientCity: _patientCity,
                                  patientDiseaseList: _patientDiseaseList);
                            });
                            await _dbHelper.insertPatientDB(_patient);
                            await FirebaseStorageHelper().saveImageLocally(userID: widget.userId, image: widget.profileImage);
                            bool isInternetAvailable = await DataConnectionChecker().hasConnection;
                            if (!isInternetAvailable) {
                              showDialog(
                                  context: context,
                                  builder: (_) => showAlert(
                                      alertMessage:
                                          'Your are not connected to Internet. Your Details and Profile Image will not be saved in cloud. Once you connect to Internet they will be saved automatically.'));
                            } else {
                              setState(() {
                                _uploadTask = true;
                              });
                              await _firestoreHandler.savePatientFirestore(_patient);
                              await FirebaseStorageHelper().uploadProfileImage(userID: widget.userId, image: widget.profileImage);
                              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen(user: _patient)));
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
