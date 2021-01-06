import 'dart:async';
import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/keys.dart';
import 'package:patient_assistant_app/screens/disease_detail_screen.dart';

class DiseaseInfoScreen extends StatefulWidget {
  @override
  _DiseaseInfoScreenState createState() => _DiseaseInfoScreenState();
}

class _DiseaseInfoScreenState extends State<DiseaseInfoScreen> {
  List diseasesNamesList = [];
  String oldPattern;
  int diseaseNameResponseCode = 200;
  TextEditingController _controller = TextEditingController();
  FocusNode _searchNode = FocusNode();
  StreamSubscription<DataConnectionStatus> listener;
  bool _hasNetwork = true;
  bool showSuffix = false;

  @override
  void initState() {
    _checkDataConnection();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _searchNode.dispose();
    listener.cancel();
  }

  void _checkDataConnection() async {
    bool temp = await DataConnectionChecker().hasConnection;
    setState(() {
      _hasNetwork = temp;
    });
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      if (status == DataConnectionStatus.connected) {
        setState(() {
          _hasNetwork = true;
        });
      } else if (status == DataConnectionStatus.disconnected) {
        setState(() {
          _hasNetwork = false;
        });
      }
    });
  }

  Future<void> diseaseInfo({String disease}) async {
    String genericURL =
        'http://www.healthos.co/api/v1/search/diseases/$disease';
    Response genericReq = await get(genericURL,
        headers: {"Authorization": "Bearer $healthOSKey"});
    setState(() {
      diseaseNameResponseCode = genericReq.statusCode;
    });
    if (genericReq.statusCode == 200) {
      setState(() {
        diseasesNamesList = jsonDecode(genericReq.body);
      });
    }
    setState(() {
      showSuffix = false;
    });
  }

  // ignore: missing_return
  Widget showSuggestions() {
    if (diseasesNamesList.length != 0) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: diseasesNamesList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kappColor1.withAlpha(50), width: 0.3),
            ),
            child: ListTile(
              dense: true,
              title: Text(
                diseasesNamesList[index]['disease_name'],
                style: TextStyle(fontSize: 15, color: kappColor1),
              ),
              subtitle: Text(
                  'Disease Id: ${diseasesNamesList[index]['disease_id'].toString()}'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => DiseaseDetailScreen(
                          diseaseDetail: diseasesNamesList[index],
                        )));
              },
            ),
          );
        },
      );
    } else if (diseasesNamesList.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            diseaseNameResponseCode == 200
                ? SvgPicture.asset('assets/images/coughing_.svg',
                    height: 250, width: 250)
                : Icon(
                    FontAwesomeIcons.exclamationTriangle,
                    size: 130,
                    color: Color(0xffdd1818).withAlpha(180),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                  diseaseNameResponseCode == 200
                      ? 'Suggestions will be shown here.'
                      : 'Error Occurred while requesting data.\nError Code: $diseaseNameResponseCode',
                  textAlign: TextAlign.center,
                  style: diseaseNameResponseCode == 200
                      ? kdialogContentStyle
                      : kdialogContentStyle.copyWith(
                          color: Color(0xffdd1818).withAlpha(180))),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.vertical + 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  child: Icon(Icons.keyboard_backspace,
                      size: 25, color: kmainHeadingColor1),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Disease info',
                  style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                      color: kmainHeadingColor1),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              height: 90,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: diseaseNameResponseCode == 200
                    ? [
                        BoxShadow(
                            color: kmainHeadingColor1.withAlpha(40),
                            offset: Offset(0, 4),
                            blurRadius: 7,
                            spreadRadius: -13)
                      ]
                    : [
                        BoxShadow(
                            color: Colors.red.shade200,
                            offset: Offset(0, 4),
                            blurRadius: 7,
                            spreadRadius: -13),
                      ],
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: _controller,
                focusNode: _searchNode,
                style: TextStyle(
                    color: diseaseNameResponseCode == 200
                        ? kmainHeadingColor1
                        : kerrorColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat'),
                cursorWidth: 1,
                cursorColor: kmainHeadingColor1,
                onChanged: (String pattern) async {
                  if (pattern.isNotEmpty && pattern != null && _hasNetwork) {}
                  Timer t;
                  if (diseaseNameResponseCode != 200 && oldPattern != pattern) {
                    setState(() {
                      showSuffix = true;
                      diseaseNameResponseCode = 200;
                      oldPattern = pattern;
                    });
                  } else if (diseaseNameResponseCode != 200) {
                    setState(() {
                      showSuffix = true;
                      diseaseNameResponseCode = 200;
                    });
                  }
                  if (oldPattern != pattern) {
                    setState(() {
                      showSuffix = true;
                      oldPattern = pattern;
                    });
                  }
                  if (pattern.isEmpty) {
                    setState(() {
                      showSuffix = false;
                      oldPattern = pattern;
                    });
                  }
                  if (_hasNetwork) {
                    t = Timer(
                        Duration(
                          seconds: 3,
                        ), () async {
                      if (oldPattern != pattern || pattern.isEmpty) {
                        t.cancel();
                      } else if (pattern.isNotEmpty) {
                        await diseaseInfo(disease: pattern);
                      }
                    });
                  }
                },
                onSubmitted: null,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  hintText: 'Try \'Malaria\' or \'Neuronal diseases\'',
                  hintStyle: TextStyle(
                      fontSize: 17,
                      color: diseaseNameResponseCode == 200
                          ? kmainHeadingColor1.withAlpha(100)
                          : kerrorColor.withAlpha(100)),
                  fillColor: diseaseNameResponseCode == 200
                      ? Colors.white
                      : Color(0xffFFF6F6),
                  filled: true,
                  helperText: null,
                  labelText: null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: diseaseNameResponseCode == 200
                          ? kmainHeadingColor1.withAlpha(200)
                          : kerrorColor.withAlpha(130),
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  suffix: showSuffix && _hasNetwork
                      ? Container(
                          margin: EdgeInsets.only(right: 20),
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                kmainHeadingColor1),
                            strokeWidth: 1.5,
                          ))
                      : GestureDetector(
                          onTap: () async {
                            if (_controller.text.isNotEmpty &&
                                _controller.text != null &&
                                _hasNetwork) {}
                            String pattern = _controller.text;
                            Timer t;
                            if (diseaseNameResponseCode != 200 &&
                                oldPattern != pattern) {
                              setState(() {
                                showSuffix = true;
                                diseaseNameResponseCode = 200;
                                oldPattern = pattern;
                              });
                            } else if (diseaseNameResponseCode != 200) {
                              setState(() {
                                showSuffix = true;
                                diseaseNameResponseCode = 200;
                              });
                            }
                            if (oldPattern != pattern) {
                              setState(() {
                                showSuffix = true;
                                oldPattern = pattern;
                              });
                            }
                            if (pattern.isEmpty) {
                              setState(() {
                                showSuffix = false;
                                oldPattern = pattern;
                              });
                            }
                            if (_hasNetwork) {
                              t = Timer(
                                  Duration(
                                    seconds: 3,
                                  ), () async {
                                if (oldPattern != pattern || pattern.isEmpty) {
                                  t.cancel();
                                } else if (pattern.isNotEmpty) {
                                  await diseaseInfo(disease: pattern);
                                }
                              });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.search,
                              size: 30,
                              color: diseaseNameResponseCode == 200
                                  ? kmainHeadingColor1
                                  : kerrorColor,
                            ),
                          ),
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: diseaseNameResponseCode == 200
                          ? kmainHeadingColor1.withAlpha(60)
                          : kerrorColor.withAlpha(60),
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: _hasNetwork || diseasesNamesList.length != 0
                    ? showSuggestions()
                    : Padding(
                        padding: EdgeInsets.only(top: 70),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.signal_wifi_off,
                              color: Colors.blueGrey,
                              size: 130,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 30, right: 30),
                              child: Text(
                                'Internet is not available. Please Check your network connection.',
                                textAlign: TextAlign.center,
                                style: kdialogContentStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
