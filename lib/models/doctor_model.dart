import 'package:patient_assistant_app/utils/utils.dart';

class Doctor {
  Doctor({
    this.doctorID,
    this.doctorName,
    this.doctorPhoneNo,
    this.doctorCountry,
    this.doctorCity,
    this.doctorsPracticeType,
    this.doctorSpecialtyList,
    this.doctorsExperience,
    this.doctorsAppointmentFee,
    this.doctorsWorkplaceName,
    this.doctorsWorkplaceAddress,
    this.doctorsPatientList,
    this.doctorsAppointments,
  });

  Doctor.fromMap(Map map) {
    if (map != null) {
      this.doctorID = map['doctorID'];
      this.doctorName = map['doctorName'];
      this.doctorPhoneNo = map['doctorPhoneNo'];
      this.doctorCountry = map['doctorCountry'];
      this.doctorCity = map['doctorCity'];
      this.doctorsPracticeType = map['practiceType'];
      this.doctorSpecialtyList = map['specialties'] != null ? stringToList(map['specialties']) : [];
      this.doctorsExperience = map['doctorExperience'];
      this.doctorsAppointmentFee = map['doctorAppointmentFee'];
      this.doctorsWorkplaceName = map['doctorsWorkplaceName'];
      this.doctorsWorkplaceAddress = map['doctorsWorkplaceAddress'];
      this.doctorsPatientList = map['doctorsPatients'] != null ? stringToList(map['doctorsPatients']) : [];
      this.doctorsAppointments = map['doctorsAppointments'] != null ? stringToList(map['doctorsAppointments']) : [];
    }
  }

  String doctorID;
  String doctorName;
  String doctorPhoneNo;
  String doctorCountry;
  String doctorCity;
  String doctorsPracticeType;
  List<String> doctorSpecialtyList = [];
  String doctorsExperience;
  String doctorsAppointmentFee;
  String doctorsWorkplaceName;
  String doctorsWorkplaceAddress;
  List<String> doctorsPatientList = [];
  List<String> doctorsAppointments = [];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> doctorMap = {};
    doctorMap['doctorID'] = doctorID;
    doctorMap['doctorName'] = doctorName;
    doctorMap['doctorPhoneNo'] = doctorPhoneNo;
    doctorMap['doctorCountry'] = doctorCountry;
    doctorMap['doctorCity'] = doctorCity;
    doctorMap['practiceType'] = doctorsPracticeType;
    doctorMap['specialties'] = doctorSpecialtyList != null || doctorSpecialtyList?.length != 0 ? doctorSpecialtyList.toString() : '';
    doctorMap['doctorExperience'] = doctorsExperience;
    doctorMap['doctorAppointmentFee'] = doctorsAppointmentFee;
    doctorMap['doctorsWorkplaceName'] = doctorsWorkplaceName;
    doctorMap['doctorsWorkplaceAddress'] = doctorsWorkplaceAddress;
    doctorMap['doctorsPatients'] = doctorsPatientList != null || doctorsPatientList?.length != 0 ? doctorsPatientList.toString() : '';
    doctorMap['doctorsAppointments'] = doctorsAppointments != null || doctorsAppointments?.length != 0 ? doctorsAppointments.toString() : '';
    return doctorMap;
  }
}
