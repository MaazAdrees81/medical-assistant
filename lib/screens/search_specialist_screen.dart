import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/screens/search_result_screen.dart';

class SearchSpecialistScreen extends StatefulWidget {
  SearchSpecialistScreen({this.user});
  final dynamic user;
  @override
  _SearchSpecialistScreenState createState() => _SearchSpecialistScreenState();
}

class _SearchSpecialistScreenState extends State<SearchSpecialistScreen> {
  TextStyle valueStyle = TextStyle(height: 1.5, color: kprimaryColor, fontSize: 19, fontWeight: FontWeight.w500);
  bool inUserCountryOnly = false;
  String country;
  String practiceType;
  List<String> userDiseases = [];
  List<String> userSpecialities = [];
  List<String> selectedSpecialities = [];
  List<String> selectedDiseases = [];
  TextEditingController _diseaseController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    country = widget.user.runtimeType == Patient ? widget.user.patientCountry : widget.user.doctorCountry;
    if (widget.user.runtimeType == Patient) {
      userDiseases.addAll(widget.user.patientDiseaseList);
    } else {
      userSpecialities.addAll(widget.user.doctorSpecialtyList);
    }
    super.initState();
  }

  Widget showAlert(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Alert !',
        style: kdialogTitleStyle,
      ),
      content: Text(
        'Your are not connected to Internet. Please check your connection and try again.',
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
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  List<Widget> drawSpecialityColumn() {
    List<Widget> specialitiesWrapList = <Widget>[];
    if (selectedSpecialities != null) {
      for (String speciality in selectedSpecialities) {
        specialitiesWrapList.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          decoration: BoxDecoration(
            gradient: ksearchScreenGradient,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                speciality,
                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSpecialities.remove(speciality);
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

  List<Widget> drawDiseaseColumn() {
    List<Widget> diseaseColumnList = <Widget>[];
    if (selectedDiseases.length != 0) {
      for (String disease in selectedDiseases) {
        diseaseColumnList.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          decoration: BoxDecoration(
            gradient: ksearchScreenGradient,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Text(
                  disease,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDiseases.remove(disease);
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

  List<Widget> userFeatureColumn() {
    List<Widget> featureWidgets = [];
    if (widget.user.runtimeType == Patient) {
      for (String disease in userDiseases) {
        featureWidgets.add(
          GestureDetector(
            onTap: () {
              setState(() {
                if (selectedDiseases.contains(disease)) {
                  selectedDiseases.remove(disease);
                } else
                  selectedDiseases.add(disease);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              decoration: selectedDiseases.contains(disease)
                  ? BoxDecoration(
                      gradient: ksearchScreenGradient,
                      borderRadius: BorderRadius.circular(25),
                    )
                  : BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    disease,
                    style:
                        TextStyle(fontSize: 12, color: selectedDiseases.contains(disease) ? Colors.white : Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      for (String speciality in userSpecialities) {
        featureWidgets.add(
          GestureDetector(
            onTap: () {
              setState(() {
                if (selectedSpecialities.contains(speciality)) {
                  selectedSpecialities.remove(speciality);
                } else
                  selectedSpecialities.add(speciality);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              decoration: selectedSpecialities.contains(speciality)
                  ? BoxDecoration(
                      gradient: ksearchScreenGradient,
                      borderRadius: BorderRadius.circular(25),
                    )
                  : BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    speciality,
                    style: TextStyle(
                        fontSize: 12, color: selectedSpecialities.contains(speciality) ? Colors.white : Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return featureWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Container(
          height: 120,
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 15, left: 15),
          decoration: BoxDecoration(
            gradient: ksearchScreenGradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SizedBox(height: 25, width: 25, child: Icon(Icons.keyboard_backspace, color: Colors.white, size: 25)),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    'Search Specialist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Add Filters',
                    style: TextStyle(color: kmainHeadingColor1, fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 23),
                  ),
                  Expanded(child: Divider(indent: 10, endIndent: 10)),
                  Icon(Icons.filter_list, color: kmainHeadingColor1, size: 25)
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  inUserCountryOnly = !inUserCountryOnly;
                });
              },
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Search for Specialists in $country only',
                      style: TextStyle(
                          fontSize: 17, wordSpacing: -0.5, color: inUserCountryOnly ? Color(0xff39C078) : Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 20),
                    height: 21,
                    width: 21,
                    child: Icon(Icons.check, color: Colors.white, size: 15),
                    decoration: BoxDecoration(
                      color: inUserCountryOnly ? Color(0xff57D583) : Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: inUserCountryOnly ? null : Border.all(color: Colors.grey.shade400, width: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            userDiseases.length == 0 && userSpecialities.length == 0
                ? SizedBox(height: 30)
                : Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 15,
                              left: 15,
                            ),
                            child: Text(widget.user.runtimeType == Patient ? 'Your Diseases' : 'Your Specialities',
                                style: TextStyle(color: kmainHeadingColor1, fontWeight: FontWeight.w500, fontSize: 21, fontFamily: 'Montserrat')),
                          ),
                          Expanded(child: Divider(indent: 5, endIndent: 20))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: userFeatureColumn(),
                        ),
                      )
                    ],
                  ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text(
                      'Select Specialities:',
                      style: TextStyle(height: 1.5, fontSize: 16, color: kmainHeadingColor1, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 33,
                    child: DropdownSearch(
                      showSelectedItem: true,
                      popupBackgroundColor: Colors.white,
                      mode: Mode.MENU,
                      items: PracticeData.allSubpractices,
                      dropDownButton: Icon(
                        Icons.arrow_drop_down,
                        color: kmainHeadingColor1,
                        size: 30,
                      ),
                      selectedItem: '\"${selectedSpecialities.length} Selected\"',
                      popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: kprimaryColor,
                          )),
                      dropdownBuilder: (context, _doctorPracticeType, String value) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                      popupItemBuilder: (context, _doctorPracticeType, isSelected) {
                        return Padding(
                          padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                          child: Text(_doctorPracticeType,
                              style: TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 15,
                              )),
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          if (!selectedSpecialities.contains(value)) {
                            selectedSpecialities.add(value);
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
                ],
              ),
            ),
            selectedSpecialities.length != 0
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: drawSpecialityColumn(),
                    ),
                  )
                : SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text(
                      'Add Diseases:',
                      style: TextStyle(height: 1.5, fontSize: 16, color: kmainHeadingColor1, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      style: valueStyle,
                      cursorColor: kprimaryColor,
                      controller: _diseaseController,
                      cursorWidth: 1,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.left,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, bottom: 8),
                        isCollapsed: true,
                        // isDense: true,
                        hintText: 'Try \"Cancer\" or \"Hepatitis\"',
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                        suffix: GestureDetector(
                            child: Icon(
                              Icons.add_circle_outline,
                              color: kprimaryColor,
                              size: 24,
                            ),
                            onTap: () {
                              if (_diseaseController.text != null &&
                                  _diseaseController.text.trim() != '' &&
                                  !selectedDiseases.contains(_diseaseController.text.trim())) {
                                setState(() {
                                  selectedDiseases.add(_diseaseController.text.trim());
                                });
                                _diseaseController.clear();
                              }
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            selectedDiseases.length != 0
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: drawDiseaseColumn(),
                    ),
                  )
                : SizedBox(height: 30),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                bool internet = await DataConnectionChecker().hasConnection;
                if (internet) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => SearchResultScreen(
                                user: widget.user,
                                selectedDiseases: selectedDiseases,
                                selectedSpecialities: selectedSpecialities,
                                inUserCountryOnly: inUserCountryOnly,
                              )));
                } else {
                  showDialog(context: _scaffoldKey.currentContext, child: showAlert(_scaffoldKey.currentContext));
                }
              },
              child: Container(
                height: 45,
                width: 110,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: kGetStartedButton.copyWith(borderRadius: BorderRadius.circular(50)),
                child: Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text(
                      'Search',
                      style: TextStyle(fontSize: 21, fontFamily: 'Montserrat', fontWeight: FontWeight.w500, color: Colors.white),
                    ))),
                    Icon(Icons.search, color: Colors.white, size: 22),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
