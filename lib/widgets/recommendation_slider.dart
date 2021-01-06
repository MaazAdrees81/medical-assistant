import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/medical_practices_data.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/utils/firestore_helper.dart';
import 'package:patient_assistant_app/widgets/recommendation_card.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class RecommendationSlider extends StatefulWidget {
  RecommendationSlider({this.currentUser, this.diseasesList});
  dynamic currentUser;
  final List<String> diseasesList;
  @override
  _RecommendationSliderState createState() => _RecommendationSliderState();
}

class _RecommendationSliderState extends State<RecommendationSlider> {
  List<Doctor> doctorRecommendation = [];

  getRecommendations() async {
    List<Doctor> doctorsList = await FirestoreHandler().getDoctors();
    List<Doctor> recommendationsList = [];
    if (widget.currentUser.runtimeType == Patient) {
      if (widget.diseasesList.isNotEmpty) {
        bool containsDiagnosis;
        for (Doctor doc in doctorsList) {
          containsDiagnosis = false;
          for (String disease in widget.diseasesList) {
            if (!containsDiagnosis) {
              for (String splitDisease in disease.toLowerCase().split(" ")) {
                if (!containsDiagnosis) {
                  if (!splitDisease.contains('disease') || !(disease.toLowerCase().split(" ").length > 1)) {
                    doc.doctorSpecialtyList.forEach((String speciality) {
                      List<String> practiceDiagnosis = PracticeData.practiceDiagnosis[speciality];
                      if (!containsDiagnosis) {
                        practiceDiagnosis.forEach((diagnosis) {
                          if (diagnosis.contains(splitDisease) && !containsDiagnosis) {
                            recommendationsList.add(doc);
                            containsDiagnosis = true;
                          }
                        });
                      }
                    });
                  }
                }
              }
            }
          }
        }
      } else {
        if (doctorsList.length < 11) {
          doctorsList.forEach((doctor) {
            if (doctor.doctorID != FirebaseAuth.instance.currentUser.uid) {
              recommendationsList.add(doctor);
            }
          });
        } else {
          for (int i = 0; i < 11; i++) {
            if (doctorsList[i].doctorID != FirebaseAuth.instance.currentUser.uid) {
              recommendationsList.add(doctorsList[i]);
            }
          }
        }
      }
    } else {
      if (doctorsList.length < 11) {
        doctorsList.forEach((doctor) {
          if (doctor.doctorID != FirebaseAuth.instance.currentUser.uid) {
            recommendationsList.add(doctor);
          }
        });
      } else {
        for (int i = 0; i < 11; i++) {
          if (doctorsList[i].doctorID != FirebaseAuth.instance.currentUser.uid) {
            recommendationsList.add(doctorsList[i]);
          }
        }
      }
    }
    setState(() {
      doctorRecommendation = recommendationsList;
    });
  }

  @override
  void initState() {
    getRecommendations();
    super.initState();
  }

  Widget shimmeringContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            margin: EdgeInsets.only(left: 25),
            padding: EdgeInsets.only(left: 60, top: 15),
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width * 0.78,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: kmainHeadingColor1.withAlpha(50), blurRadius: 12)],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                height: 70,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: kmainHeadingColor1.withAlpha(40),
                      offset: Offset(-3, 0),
                      blurRadius: 9,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: doctorRecommendation.length == 0
          ? shimmeringContainer()
          : Container(
              child: ListView.builder(
                cacheExtent: doctorRecommendation.length / 1,
                itemCount: doctorRecommendation.length,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return RecommendationCard(doctor: doctorRecommendation[index], currentUser: widget.currentUser);
                },
              ),
            ),
    );
  }
}
