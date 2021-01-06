import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/screens/form_screen.dart';
import 'package:patient_assistant_app/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpCard extends StatefulWidget {
  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController;
  TextEditingController _passController1;
  TextEditingController _passController2;
  FocusNode _emailNode;
  FocusNode _passNode1;
  FocusNode _passNode2;
  String _emailErrorText;
  String _password1ErrorText;
  String _password2ErrorText;
  String _email;
  String _password1;
  String _password2;
  bool _isInternetAvailable;
  bool _isEmailValidating = false;
  bool _isPass1Validating = false;
  bool _isPass2Validating = false;
  bool _showIndicator = false;
  Color _suffixEye1Color = Colors.green.shade100;
  Color _suffixEye2Color = Colors.green.shade100;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passController1 = TextEditingController();
    _passController2 = TextEditingController();
    _emailNode = FocusNode();
    _passNode1 = FocusNode();
    _passNode2 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passNode1.dispose();
    _passNode2.dispose();
    _emailController.dispose();
    _passController1.dispose();
    _passController2.dispose();
    super.dispose();
  }

  void _emailValidator(String email) {
    email == null ? email = '' : email = email;
    if (_isEmailValidating) {
      if (RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(email)) {
        setState(() {
          _emailErrorText = null;
        });
      } else if (email == '') {
        setState(() {
          _emailErrorText = 'This field cannot be left empty';
        });
      } else
        setState(() {
          _emailErrorText = "Please enter a valid email.";
        });
    }
  }

  void _password1Validator(String password1) {
    if (_isPass1Validating) {
      if (password1 == null || password1 == '') {
        setState(() {
          _password1ErrorText = 'This field cannot be left empty';
        });
      } else if (password1.length <= 5) {
        setState(() {
          _password1ErrorText = 'Enter at least 6 character long password';
        });
      } else if (password1.contains(' ')) {
        setState(() {
          _password1ErrorText = 'Password cannot contain whitespaces';
        });
      } else
        setState(() {
          _password1ErrorText = null;
        });
    }
    setState(() {
      if (_obscureText1 != false && _password1ErrorText == null) {
        _suffixEye1Color = Colors.green.shade100;
      } else if (_obscureText1 != false && _password1ErrorText != null) {
        _suffixEye1Color = Colors.red.shade100;
      } else if (_obscureText1 != true && _password1ErrorText == null) {
        _suffixEye1Color = kprimaryColor;
      } else if (_obscureText1 != true && _password1ErrorText != null) {
        _suffixEye1Color = kerrorColor;
      }
    });
  }

  void _password2Validator(String password2) {
    if (_isPass2Validating) {
      if (password2 != null && _password1 != null && password2 != _password1) {
        setState(() {
          _password2ErrorText = 'Password does not match';
        });
      } else if (password2 == null || password2 == '') {
        setState(() {
          _password2ErrorText = 'This field cannot be left empty';
        });
      } else if (password2.length <= 5) {
        setState(() {
          _password2ErrorText = 'Enter at least 6 character long password';
        });
      } else if (password2.contains(' ')) {
        setState(() {
          _password2ErrorText = 'Password cannot contain whitespaces';
        });
      } else
        setState(() {
          _password2ErrorText = null;
        });
    }
    setState(() {
      if (_obscureText2 != false && _password2ErrorText == null) {
        _suffixEye2Color = Colors.green.shade100;
      } else if (_obscureText2 != false && _password2ErrorText != null) {
        _suffixEye2Color = Colors.red.shade100;
      } else if (_obscureText2 != true && _password2ErrorText == null) {
        _suffixEye2Color = kprimaryColor;
      } else if (_obscureText2 != true && _password2ErrorText != null) {
        _suffixEye2Color = kerrorColor;
      }
    });
  }

  Widget showAlert({String alertMessage, String userID, String userEmail}) {
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
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  void _signUpUsers() async {
    _isInternetAvailable = await DataConnectionChecker().hasConnection;
    if (_isInternetAvailable) {
      try {
        final newUser = await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password1);
        if (newUser != null) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          await _prefs.setString('signed_in_user_id', newUser.user.uid);
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => FormScreen(userId: newUser.user.uid, userEmail: newUser.user.email)));
        } else {
          setState(() {
            _showIndicator = false;
          });
          showDialog(context: context, builder: (_) => showAlert(alertMessage: 'There was some error while signing in. Please try again.'));
        }
      } catch (e) {
        setState(() {
          _showIndicator = false;
        });
        if (e.toString().contains('[firebase_auth/email-already-in-use]')) {
          setState(() {
            _emailErrorText = 'This email is already in use by another account.';
          });
        } else if (e.toString().contains('[cloud_firestore/unavailable]')) {
          showDialog(
              context: context,
              builder: (_) => showAlert(
                  alertMessage: 'This typically indicates that your device does not have a healthy Internet connection at the moment. Try again.'));
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
                  'Sign Up',
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
                  'Create an Account to get started.',
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
            textController: _emailController,
            node: _emailNode,
            readOnly: _showIndicator,
            contentPadding: null,
            labelText: 'Email',
            helperText: "",
            hintText: null,
            textAlign: TextAlign.center,
            errorText: _emailErrorText,
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
              FocusScope.of(context).requestFocus(_passNode1);
            },
            onFieldSubmitted: (String email) {
              setState(() {
                _isEmailValidating = true;
              });
              _emailValidator(_email);
            },
          ),
//          Password Field
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.103,
            width: MediaQuery.of(context).size.width * 0.84, // /1.2
            textController: _passController1,
            node: _passNode1,
            readOnly: _showIndicator,
            contentPadding: null,
            textAlign: TextAlign.center,
            labelText: 'Password',
            helperText: 'At least 6 characters and whitespaces are not allowed.',
            hintText: null,
            errorText: _password1ErrorText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: _obscureText1,
            suffix: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: _suffixEye1Color,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText1 = !_obscureText1;
                    if (_obscureText1 != false && _password1ErrorText == null) {
                      _suffixEye1Color = Colors.green.shade100;
                    } else if (_obscureText1 != false && _password1ErrorText != null) {
                      _suffixEye1Color = Colors.red.shade100;
                    } else if (_obscureText1 != true && _password1ErrorText == null) {
                      _suffixEye1Color = kprimaryColor;
                    } else if (_obscureText1 != true && _password1ErrorText != null) {
                      _suffixEye1Color = kerrorColor;
                    }
                  });
                }),
            onChanged: (value) {
              setState(() {
                _password1 = value;
              });
              _password1Validator(_password1);
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_passNode2);
            },
            onFieldSubmitted: (String email) {
              setState(() {
                _isPass1Validating = true;
              });
              _password1Validator(_password1);
            },
          ),
//            Confirm Password Field
          CustomTextFields(
            height: 65, //MediaQuery.of(context).size.height * 0.103,
            width: MediaQuery.of(context).size.width * 0.84, // /1.2
            textController: _passController2,
            node: _passNode2,
            readOnly: _showIndicator,
            contentPadding: null,
            textAlign: TextAlign.center,
            labelText: 'Password',
            helperText: 'Confirm your password.',
            hintText: null,
            errorText: _password2ErrorText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: _obscureText2,
            suffix: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: _suffixEye2Color,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText2 = !_obscureText2;
                    if (_obscureText2 != false && _password2ErrorText == null) {
                      _suffixEye2Color = Colors.green.shade100;
                    } else if (_obscureText2 != false && _password2ErrorText != null) {
                      _suffixEye2Color = Colors.red.shade100;
                    } else if (_obscureText2 != true && _password2ErrorText == null) {
                      _suffixEye2Color = kprimaryColor;
                    } else if (_obscureText2 != true && _password2ErrorText != null) {
                      _suffixEye2Color = kerrorColor;
                    }
                  });
                }),
            onChanged: (value) {
              setState(() {
                _password2 = value;
              });
              _password2Validator(_password2);
            },
            onEditingComplete: () {
              _passNode2.unfocus();
            },
            onFieldSubmitted: (String email) {
              setState(() {
                _isPass2Validating = true;
              });
              _password2Validator(_password2);
            },
          ),
          _showIndicator
              ? Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('\u2022\u2022\u2022 Signing up \u2022\u2022\u2022', style: kprocessInfoStyle),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      _passNode1.unfocus();
                      _passNode2.unfocus();
                      _emailNode.unfocus();
                      _emailValidator(_email);
                      _password1Validator(_password1);
                      _password2Validator(_password2);
                      if (_emailErrorText == null &&
                          _password1ErrorText == null &&
                          _password2ErrorText == null &&
                          _email != null &&
                          _password1 != null &&
                          _password1 != null &&
                          _password1 == _password2) {
                        setState(() {
                          _showIndicator = true;
                        });
                        _signUpUsers();
                      } else {
                        setState(() {
                          _isEmailValidating = true;
                          _isPass1Validating = true;
                          _isPass2Validating = true;
                        });
                      }
                    },
                    child: Container(
                        width: 100,
                        height: 35,
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: kloginBtn,
                          ),
                        ),
                        decoration: kGetStartedButton),
                  ),
                )
        ],
      ),
    );
  }
}
