import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/search_card.dart';

class SearchResultScreen extends StatefulWidget {
  SearchResultScreen({this.user, this.selectedDiseases, this.selectedSpecialities, this.inUserCountryOnly});
  final dynamic user;
  final List<String> selectedSpecialities;
  final List<String> selectedDiseases;
  final bool inUserCountryOnly;
  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  String country;
  bool hasSearched = false;
  List<Doctor> searchResults;
  List<List<String>> searchedKeywords = [];
  BoxDecoration bubbleDecoration = BoxDecoration(
    color: Color(0xfff8f8f8),
    borderRadius: BorderRadius.circular(25),
  );
  TextStyle bubbleStyle = TextStyle(fontSize: 12, color: kappColor1, fontWeight: FontWeight.w500);

  @override
  initState() {
    country = widget.user.runtimeType == Patient ? widget.user.patientCountry : widget.user.doctorCountry;
    searchDoctors();
    super.initState();
  }

  searchDoctors() async {
    List<Doctor> allDoctors = await FirestoreHandler().getDoctors();
    List<Doctor> results = [];
    List<List<String>> keywords = [];

    if (widget.selectedSpecialities.length != 0) {
      for (int docIndex = 0; docIndex < allDoctors.length; docIndex++) {
        Doctor doc = allDoctors[docIndex];
        List<String> docKeywords = [];
        if (widget.inUserCountryOnly) {
          if (doc.doctorCountry == country) {
            for (String speciality in widget.selectedSpecialities) {
              doc.doctorSpecialtyList.forEach((String docSpec) {
                if (speciality == docSpec) {
                  docKeywords.add(speciality);
                }
              });
            }
          }
        } else {
          for (String speciality in widget.selectedSpecialities) {
            doc.doctorSpecialtyList.forEach((String docSpec) {
              if (speciality == docSpec) {
                docKeywords.add(speciality);
              }
            });
          }
        }
        if (widget.user.runtimeType == Doctor) {
          if (docKeywords.length != 0 && widget.user.doctorID != doc.doctorID) {
            results.add(doc);
            keywords.add(docKeywords);
          }
        } else {
          if (docKeywords.length != 0) {
            results.add(doc);
            keywords.add(docKeywords);
          }
        }
      }
    }

    if (widget.selectedDiseases.length != 0) {
      for (int docIndex = 0; docIndex < allDoctors.length; docIndex++) {
        Doctor doc = allDoctors[docIndex];
        List<String> docKeywords = [];
        if (widget.inUserCountryOnly) {
          if (doc.doctorCountry == country) {
            for (String disease in widget.selectedDiseases) {
              for (String splitDisease in disease.toLowerCase().split(" ")) {
                if (!splitDisease.contains('disease') || !(disease.split(" ").length > 1)) {
                  doc.doctorSpecialtyList.forEach((String speciality) {
                    List<String> practiceDiagnosis = PracticeData.practiceDiagnosis[speciality];
                    practiceDiagnosis.forEach((String diagnosis) {
                      if (diagnosis.contains(splitDisease) && !docKeywords.contains(disease)) {
                        docKeywords.add(disease);
                      }
                    });
                  });
                }
              }
            }
          }
        } else {
          for (String disease in widget.selectedDiseases) {
            for (String splitDisease in disease.toLowerCase().split(" ")) {
              if (!splitDisease.contains('disease') || !(disease.split(" ").length > 1)) {
                doc.doctorSpecialtyList.forEach((String speciality) {
                  List<String> practiceDiagnosis = PracticeData.practiceDiagnosis[speciality];
                  practiceDiagnosis.forEach((String diagnosis) {
                    if (diagnosis.contains(splitDisease) && !docKeywords.contains(disease)) {
                      docKeywords.add(disease);
                    }
                  });
                });
              }
            }
          }
        }
        if (widget.user.runtimeType == Doctor) {
          if (docKeywords.length != 0 && widget.user.doctorID != doc.doctorID) {
            if (results.contains(doc)) {
              int index = results.indexOf(doc);
              keywords[index].addAll(docKeywords);
            } else {
              results.add(doc);
              keywords.add(docKeywords);
            }
          }
        } else {
          if (docKeywords.length != 0) {
            if (results.contains(doc)) {
              int index = results.indexOf(doc);
              keywords[index].addAll(docKeywords);
            } else {
              results.add(doc);
              keywords.add(docKeywords);
            }
          }
        }
      }
    }
    if (widget.selectedDiseases.length == 0 && widget.selectedSpecialities.length == 0) {
      if (widget.inUserCountryOnly) {
        if (widget.user.runtimeType == Doctor) {
          for (Doctor doc in allDoctors) {
            if (doc.doctorCountry == country && widget.user.doctorID != doc.doctorID) {
              results.add(doc);
            }
          }
        } else {
          for (Doctor doc in allDoctors) {
            if (doc.doctorCountry == country) {
              results.add(doc);
            }
          }
        }
      } else {
        if (widget.user.runtimeType == Doctor) {
          for (Doctor doc in allDoctors) {
            if (widget.user.doctorID != doc.doctorID) {
              results.add(doc);
            }
          }
        } else {
          results = allDoctors;
        }
      }
    }
    setState(() {
      searchedKeywords = keywords;
      searchResults = results;
    });
  }

  Widget showFeaturesDialog({BuildContext context, String title, List<String> featureList}) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: EdgeInsets.all(0),
      content: Builder(builder: (context) {
        List<Widget> featureContainers = [];
        for (String feature in featureList) {
          featureContainers.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff57D583), Color(0xff46A98C)], //Color(0xb838ef7d)
                    end: Alignment.centerRight,
                    begin: Alignment.topLeft),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      feature,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5, top: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                          color: kappColor1,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 22, color: Color(0xff57D583), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: featureContainers,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> selectedFeatureColumn({List<String> featureList}) {
    List<Widget> featureColumnList = <Widget>[];
    if (featureList.length != 0) {
      if (featureList.length > 3) {
        for (int i = 0; i < 3; i++) {
          featureColumnList.add(Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: bubbleDecoration,
            child: Text(
              featureList[i],
              overflow: TextOverflow.ellipsis,
              style: bubbleStyle,
            ),
          ));
        }
      } else {
        for (String disease in featureList) {
          featureColumnList.add(Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: bubbleDecoration,
            child: Text(
              disease,
              overflow: TextOverflow.ellipsis,
              style: bubbleStyle,
            ),
          ));
        }
      }
    }
    return featureColumnList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            toolbarHeight: 80,
            leading: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  child: Icon(Icons.keyboard_backspace, size: 25, color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
            expandedHeight: MediaQuery.of(context).size.height * 0.48,
            backgroundColor: Color(0xfff8f8f8),
            snap: true,
            floating: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.48 + MediaQuery.of(context).viewPadding.vertical,
                    color: Color(0xfff8f8f8),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20 + MediaQuery.of(context).viewPadding.vertical),
                    height: MediaQuery.of(context).size.height * 0.48,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xff57D583), Color(0xff46A98C)], //Color(0xb838ef7d)
                            end: Alignment.centerRight,
                            begin: Alignment.topLeft),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('In', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white)),
                              Container(
                                margin: EdgeInsets.only(left: 4),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: LimitedBox(
                                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                                  child: Text(widget.inUserCountryOnly ? '$country only' : 'all Countries',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w500, color: kappColor1)),
                                ),
                                decoration: bubbleDecoration,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Specialities', style: kloginBtn), Expanded(child: Divider(indent: 10, color: Colors.white70))],
                          ),
                        ),
                        widget.selectedSpecialities.length != 0
                            ? Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: selectedFeatureColumn(featureList: widget.selectedSpecialities),
                                      ),
                                    ),
                                    widget.selectedSpecialities.length > 3
                                        ? GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  child: showFeaturesDialog(
                                                      context: context, featureList: widget.selectedSpecialities, title: 'Selected Specialities'));
                                            },
                                            child: Container(
                                                height: 35,
                                                padding: EdgeInsets.only(right: 10, left: 5),
                                                alignment: Alignment.center,
                                                child: Text('+${widget.selectedSpecialities.length - 3}', style: kloginBtn)),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                child: Text('None Selected', style: bubbleStyle.copyWith(color: kappColor1)),
                                decoration: bubbleDecoration,
                              ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 10, bottom: 6, right: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Diseases', style: kloginBtn), Expanded(child: Divider(indent: 10, color: Colors.white70))],
                          ),
                        ),
                        widget.selectedDiseases.length != 0
                            ? Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: selectedFeatureColumn(featureList: widget.selectedDiseases),
                                      ),
                                    ),
                                    widget.selectedDiseases.length > 3
                                        ? GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  child: showFeaturesDialog(
                                                      context: context, featureList: widget.selectedDiseases, title: 'Selected Diseases'));
                                            },
                                            child: Container(
                                                height: 35,
                                                padding: EdgeInsets.only(right: 10, left: 5),
                                                alignment: Alignment.center,
                                                child: Text('+${widget.selectedDiseases.length - 3}', style: kloginBtn)),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                child: Text('None Selected', style: bubbleStyle),
                                decoration: bubbleDecoration,
                              )
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      height: 40,
                      width: 110,
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      child:
                          Text('Results', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white)),
                      decoration: kGetStartedButton,
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            searchResults == null
                ? Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : searchResults.length != 0
                    ? Column(
                        children: List.generate(
                            searchResults.length,
                            (index) => SearchCard(
                                  user: widget.user,
                                  doctor: searchResults[index],
                                  keyword: searchedKeywords.length != 0 ? searchedKeywords[index] : [],
                                  inUserCountryOnly: widget.inUserCountryOnly,
                                )),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              'assets/images/not_found.svg',
                              height: 150,
                            ),
                            Text(
                              'No results found matching your query',
                              style: kdialogContentStyle,
                            ),
                          ],
                        ),
                      ),
          ]))
        ],
      ),
    );
  }
}
