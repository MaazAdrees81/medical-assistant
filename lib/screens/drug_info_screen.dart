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
import 'package:patient_assistant_app/screens/drug_detail_screen.dart';

class DrugInfoScreen extends StatefulWidget {
  @override
  _DrugInfoScreenState createState() => _DrugInfoScreenState();
}

class _DrugInfoScreenState extends State<DrugInfoScreen> {
  Map selectedItem;
  Map selectedItemCopy = {};
  String oldPattern;
  int genericsNameResponseCode = 200;
  int genericsIDResponseCode = 200;
  int genericsInteractionResponseCode = 200;
  bool showSuffix = false;
  List<dynamic> genericsNamesList;
  Map<String, dynamic> genericInfo;
  Map<String, dynamic> genericInteractions;
  TextEditingController _controller = TextEditingController();
  FocusNode _searchNode = FocusNode();
  StreamSubscription<DataConnectionStatus> listener;
  bool _hasNetwork = true;

  @override
  void initState() {
    selectedItem = {};
    selectedItemCopy = {};
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

  Future genericInfoByID({String genericID, String name}) async {
    String genericURL =
        'http://www.healthos.co/api/v1/medicines/generics/$genericID';
    String genericInteractionURL =
        'http://www.healthos.co/api/v1/interactions/generics/$genericID';

    Response genericResponse = await get(genericURL,
        headers: {"Authorization": "Bearer $healthOSKey"});
    setState(() {
      genericsIDResponseCode = genericResponse.statusCode;
    });
    if (genericResponse.statusCode == 200) {
      setState(() {
        genericInfo = jsonDecode(genericResponse.body);
        genericInteractions = null;
      });

      Response genericInteractionResponse = await get(genericInteractionURL,
          headers: {"Authorization": "Bearer $healthOSKey"});
      setState(() {
        genericsInteractionResponseCode = genericInteractionResponse.statusCode;
      });
      if (genericInteractionResponse.statusCode == 200) {
        setState(() {
          genericInteractions = jsonDecode(genericInteractionResponse.body);
        });
      }
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => DrugDetailScreen(
                  title: name,
                  genericInfo: genericInfo,
                  genericInteractions: genericInteractions)));
      setState(() {
        selectedItemCopy = selectedItem;
        selectedItem = {};
      });
    }
  }

  Future genericsByName({String genericName}) async {
    Response response = await get(
        'http://www.healthos.co/api/v1/autocomplete/medicines/generics/$genericName',
        headers: {"Authorization": "Bearer "});
    setState(() {
      genericsNameResponseCode = response.statusCode;
    });
    if (response.statusCode == 200) {
      setState(() {
        genericsNamesList = jsonDecode(response.body);
        genericsIDResponseCode = 200;
        genericsInteractionResponseCode = 200;
      });
    }
    setState(() {
      showSuffix = false;
    });
  }

  // ignore: missing_return
  Widget trailing(int index) {
    if (selectedItem.length == 0 || !_hasNetwork) {
      return null;
    } else if (selectedItem['name'] == genericsNamesList[index]['name'] &&
        genericsIDResponseCode == 200 &&
        genericsInteractionResponseCode == 200) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          ),
          Text('Fetching Data', style: TextStyle(fontSize: 10))
        ],
      );
    } else if ((genericsIDResponseCode != 200 ||
            genericsInteractionResponseCode != 200) &&
        selectedItem['name'] == genericsNamesList[index]['name']) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Error! Try again',
              softWrap: true, style: TextStyle(color: kerrorColor)),
          Text(
              'Error: ${genericsIDResponseCode != 200 ? genericsIDResponseCode : genericsInteractionResponseCode}',
              softWrap: true,
              style: TextStyle(color: kerrorColor))
        ],
      );
    }
  }

  // ignore: missing_return
  Widget showSuggestions() {
    if (genericsNamesList != null) {
      //&& _controller.text != ''
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: genericsNamesList.length,
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
                genericsNamesList[index]['name'],
                style: TextStyle(
                    fontSize: 15,
                    color: selectedItem['name'] ==
                                genericsNamesList[index]['name'] &&
                            genericsIDResponseCode != 200
                        ? kerrorColor
                        : kappColor1),
              ),
              subtitle: Text(
                  'Generic Id: ${genericsNamesList[index]['generic_id'].toString()}'),
              trailing: trailing(index),
              onTap: () async {
                setState(() {
                  selectedItem.addAll({
                    'name': genericsNamesList[index]['name'],
                    'generic_id': genericsNamesList[index]['generic_id']
                  });
                  genericsIDResponseCode = 200;
                  genericsInteractionResponseCode = 200;
                });
                if (selectedItemCopy['generic_id'] ==
                        genericsNamesList[index]['generic_id'] &&
                    genericInfo != null) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => DrugDetailScreen(
                              title: genericsNamesList[index]['name'],
                              genericInfo: genericInfo,
                              genericInteractions: genericInteractions)));
                  setState(() {
                    selectedItemCopy = selectedItem;
                    selectedItem = {};
                  });
                } else {
                  await genericInfoByID(
                      name: genericsNamesList[index]['name'],
                      genericID:
                          genericsNamesList[index]['generic_id'].toString());
                }
              },
            ),
          );
        },
      );
    } else if (genericsNamesList == null) {
      return Padding(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            genericsNameResponseCode == 200
                ? SvgPicture.asset('assets/images/pills(2).svg',
                    height: 180, width: 180)
                : Icon(
                    FontAwesomeIcons.exclamationTriangle,
                    size: 130,
                    color: Color(0xffdd1818).withAlpha(180),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                  genericsNameResponseCode == 200
                      ? 'Suggestions will be shown here.'
                      : 'Error Occurred while requesting data.\nError Code: $genericsNameResponseCode',
                  textAlign: TextAlign.center,
                  style: genericsNameResponseCode == 200
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
                  'Drugs info',
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
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              height: 90, //MediaQuery.of(context).size.height * 0.14,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: genericsNameResponseCode == 200
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
                    color: genericsNameResponseCode == 200
                        ? kmainHeadingColor1
                        : kerrorColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat'),
                cursorWidth: 1,
                cursorColor: kmainHeadingColor1,
                onChanged: (String pattern) async {
                  if (pattern != '' && pattern != null && _hasNetwork) {
                    Timer t;
                    if (genericsNameResponseCode != 200 &&
                        oldPattern != pattern) {
                      setState(() {
                        showSuffix = true;
                        genericsNameResponseCode = 200;
                        oldPattern = pattern;
                      });
                    } else if (genericsNameResponseCode != 200) {
                      setState(() {
                        showSuffix = false;
                        genericsNameResponseCode = 200;
                      });
                    }
                    if (oldPattern != pattern && selectedItem.length == 0) {
                      setState(() {
                        showSuffix = true;
                        oldPattern = pattern;
                      });
                    } else if (oldPattern != pattern &&
                        selectedItem.length != 0) {
                      setState(() {
                        selectedItemCopy = selectedItem;
                        selectedItem = {};
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
                          await genericsByName(genericName: pattern);
                        }
                      });
                    }
                  }
                },
                onSubmitted: null,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  hintText: 'Try \'Acarbose\' or \'Paracetamol\'',
                  hintStyle: TextStyle(
                      fontSize: 17,
                      color: genericsNameResponseCode == 200
                          ? kmainHeadingColor1.withAlpha(100)
                          : kerrorColor.withAlpha(100)),
                  fillColor: genericsNameResponseCode == 200
                      ? Colors.white
                      : Color(0xffFFF6F6),
                  filled: true,
                  helperText: null,
                  labelText: null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: genericsNameResponseCode == 200
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
                            if (_controller.text != '' &&
                                _controller.text != null &&
                                _hasNetwork) {
                              String pattern = _controller.text;
                              Timer t;
                              if (genericsNameResponseCode != 200 &&
                                  oldPattern != pattern) {
                                setState(() {
                                  showSuffix = true;
                                  genericsNameResponseCode = 200;
                                  oldPattern = pattern;
                                });
                              } else if (genericsNameResponseCode != 200) {
                                setState(() {
                                  showSuffix = true;
                                  genericsNameResponseCode = 200;
                                });
                              }
                              if (oldPattern != pattern &&
                                  selectedItem.length == 0) {
                                setState(() {
                                  showSuffix = true;
                                  oldPattern = pattern;
                                });
                              }
                              if (_hasNetwork) {
                                t = Timer(Duration(seconds: 2), () async {
                                  if (oldPattern != pattern ||
                                      pattern.isEmpty) {
                                    t.cancel();
                                  } else if (pattern.isNotEmpty) {
                                    await genericsByName(genericName: pattern);
                                  }
                                });
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.search,
                              size: 30,
                              color: genericsNameResponseCode == 200
                                  ? kmainHeadingColor1
                                  : kerrorColor,
                            ),
                          ),
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: genericsNameResponseCode == 200
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
                child: _hasNetwork || genericsNamesList != null
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
