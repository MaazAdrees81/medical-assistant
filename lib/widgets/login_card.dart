import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/form_screen.dart';
import 'package:patient_assistant_app/screens/home_screen.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/fire_storage_helper.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DBHelper _dbHelper = DBHelper();
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
  TextEditingController _emailController;
  TextEditingController _passController;
  FocusNode _emailNode;
  FocusNode _passNode;
  String _email;
  String _password;
  String _emailErrorText;
  String _passwordErrorText;
  bool _isInternetAvailable;
  Color _suffixEyeColor = Colors.green.shade100;
  bool _obscureText = true;
  bool _showIndicator = false;
  String progressString = 'Logging in';

  @override
  void initState() {
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _emailNode = FocusNode();
    _passNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passNode.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void obscureIconColor() {
    if (_obscureText != false && _passwordErrorText == null) {
      _suffixEyeColor = Colors.green.shade100;
    } else if (_obscureText != false && _passwordErrorText != null) {
      _suffixEyeColor = Colors.red.shade100;
    } else if (_obscureText != true && _passwordErrorText == null) {
      _suffixEyeColor = kprimaryColor;
    } else if (_obscureText != true && _passwordErrorText != null) {
      _suffixEyeColor = kerrorColor;
    }
  }

  void _emailValidator(String email) {
    if (email == null || email == '') {
      setState(() {
        _emailErrorText = 'This field cannot be left empty.';
      });
    } else
      setState(() {
        _emailErrorText = null;
      });
  }

  void _passwordValidator(String password) {
    if (password == null || password == '') {
      setState(() {
        _passwordErrorText = 'This field cannot be left empty.';
      });
    } else
      setState(() {
        _passwordErrorText = null;
      });
    setState(() {
      obscureIconColor();
    });
  }

  Widget showAlert({String alertMessage, String userID, String userEmail}) {
    return AlertDialog(
      title: Text(
        'Alert !',
        style: kdialogTitleStyle,
      ),
      content: Text(
        alertMessage,
        style: kalertDescriptionStyle,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: <Widget>[
        GestureDetector(
          child: Container(
              constraints: BoxConstraints.tightFor(width: 48, height: 48),
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
              decoration: kAlertBtnDecoration),
          onTap: () {
            if (userID != null && userEmail != null) {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => FormScreen(userId: userID, userEmail: userEmail)));
            } else {
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }

  void _loginUser() async {
    _isInternetAvailable = await DataConnectionChecker().hasConnection;
    if (_isInternetAvailable) {
      try {
        final user = await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
        if (user != null) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          await _prefs.setString('signed_in_user_id', user.user.uid);
          setState(() {
            progressString = 'Loading User';
          });
          dynamic userData = await _firestoreHandler.checkIdForUserFirestore(id: user.user.uid);
          await FirebaseStorageHelper().checkImageIsPresent(user.user.uid);
          if (userData != null) {
            setState(() {
              progressString = 'Fetching Data';
            });
            if (userData.runtimeType == Patient) {
              await _dbHelper.insertPatientDB(userData);
              if (userData.patientsDoctorList.length != 0) {
                for (String contact in userData.patientsDoctorList) {
                  Doctor doc = await _firestoreHandler.getDoctorFirestore(contact);
                  await _dbHelper.insertDoctorDB(doc);
                }
              }
            } else {
              await _dbHelper.insertDoctorDB(userData);
              if (userData.doctorsPatientList.length != 0) {
                for (String contact in userData.doctorsPatientList) {
                  Patient patient = await _firestoreHandler.getPatientFirestore(contact);
                  await _dbHelper.insertPatientDB(patient);
                }
              }
            }
            await _firestoreHandler.downloadUserChat(userData.runtimeType == Patient ? userData.patientID : userData.doctorID);
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => HomeScreen(
                  user: userData,
                ),
              ),
            );
          }
          if (userData == null) {
            setState(() {
              _showIndicator = false;
              progressString = 'Logging in';
            });
            showDialog(
                context: context,
                builder: (_) => showAlert(
                    alertMessage: 'No user data was found in the app or cloud storage. You have to proceed to Form Screen to enter details.',
                    userID: user.user.uid,
                    userEmail: user.user.email));
          }
        } else {
          setState(() {
            _showIndicator = false;
            progressString = 'Logging in';
          });
          showDialog(context: context, builder: (_) => showAlert(alertMessage: 'There was some error while logging in. Please try again.'));
        }
      } catch (e) {
        setState(() {
          _showIndicator = false;
          progressString = 'Logging in';
        });
        if (e.toString().contains('[firebase_auth/wrong-password]')) {
          setState(() {
            _passwordErrorText = 'Wrong Password. Try again.';
            obscureIconColor();
          });
        } else if (e.toString().contains('[firebase_auth/user-not-found]')) {
          setState(() {
            _emailErrorText = 'No user found associated with this email.';
          });
        } else if (e.toString().contains('[firebase_auth/invalid-email]')) {
          setState(() {
            _emailErrorText = 'Please enter a valid email.';
          });
        } else if (e.toString().contains('[cloud_firestore/unavailable]')) {
          showDialog(
              context: context,
              builder: (_) => showAlert(
                  alertMessage: 'This typically indicates that your device does not have a healthy Internet connection at the moment. Try again.'));
        } else {
          setState(() {
            _showIndicator = false;
            progressString = 'Logging in';
          });
          showDialog(context: context, builder: (_) => showAlert(alertMessage: 'There was some error while logging in. Please try again.'));
        }
      }
    } else {
      setState(() {
        _showIndicator = false;
      });
      showDialog(
          context: context,
          builder: (_) => showAlert(alertMessage: 'Your are not connected to Internet. Please check your connection and try again.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(
                    height: 1.4,
                    color: kappColor1,
                    fontSize: 38,
                    letterSpacing: 1.2,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 25),
            child: Row(
              children: <Widget>[
                Text(
                  'Log into your Account to get started.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: kmainHeadingColor1,
                    letterSpacing: 1.3,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
//          Email Field
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.103,
            width: MediaQuery.of(context).size.width * 0.84, // /1.2
            errorText: _emailErrorText,
            textController: _emailController,
            node: _emailNode,
            readOnly: _showIndicator,
            contentPadding: null,
            textAlign: TextAlign.center,
            labelText: 'Email',
            helperText: "",
            hintText: null,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            obscureText: false,
            suffix: null,
            onChanged: (value) {
              setState(() {
                _email = value;
              });
              _emailValidator(_email);
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_passNode);
            },
            onFieldSubmitted: null,
          ),
//          Password Field
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.103,
            width: MediaQuery.of(context).size.width * 0.84,
            errorText: _passwordErrorText,
            textController: _passController,
            node: _passNode,
            readOnly: _showIndicator,
            textAlign: TextAlign.center,
            contentPadding: null,
            labelText: 'Password',
            helperText: '',
            hintText: null,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: _obscureText,
            suffix: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: _suffixEyeColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                    obscureIconColor();
                  });
                }),
            onChanged: (value) {
              setState(() {
                _password = value;
              });
              _passwordValidator(_password);
            },
            onEditingComplete: () {
              _passNode.unfocus();
            },
            onFieldSubmitted: null,
          ),
          _showIndicator
              ? Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('\u2022\u2022\u2022 $progressString \u2022\u2022\u2022', style: kprocessInfoStyle),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      _passNode.unfocus();
                      _emailNode.unfocus();
                      _emailValidator(_email);
                      _passwordValidator(_password);
                      if (_passwordErrorText == null && _emailErrorText == null) {
                        setState(() {
                          _showIndicator = true;
                        });
                        _loginUser();
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      child: Center(
                        child: Text(
                          'Login',
                          style: kloginBtn,
                        ),
                      ),
                      decoration: kGetStartedButton,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
