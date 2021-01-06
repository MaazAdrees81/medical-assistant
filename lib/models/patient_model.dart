import 'package:patient_assistant_app/utils/utils.dart';

class Patient {
  Patient(
      {this.patientID,
      this.patientName,
      this.patientAge,
      this.patientCountry,
      this.patientCity,
      this.patientDiseaseList,
      this.patientsDoctorList,
      this.patientsAlarms,
      this.patientAppointments});

  Patient.fromMap(Map map) {
    if (map != null) {
      this.patientID = map['patientID'];
      this.patientName = map['patientName'];
      this.patientAge = map['patientAge'];
      this.patientCountry = map['patientCountry'];
      this.patientCity = map['patientCity'];
      this.patientDiseaseList = map['diseases'] != null ? stringToList(map['diseases']) : [];
      this.patientsDoctorList = map['patientDoctors'] != null ? stringToList(map['patientDoctors']) : [];
      this.patientsAlarms = map['patientAlarms'] != null ? stringToList(map['patientAlarms']) : [];
      this.patientAppointments = map['patientAppointments'] != null ? stringToList(map['patientAppointments']) : [];
    }
  }

  String patientID;
  String patientName;
  String patientAge;
  String patientCountry;
  String patientCity;
  List<String> patientDiseaseList = [];
  List<String> patientsDoctorList = []; // contains doctors userId's
  List<String> patientsAlarms = [];
  List<String> patientAppointments = [];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> patientMap = {};
    patientMap['patientID'] = patientID;
    patientMap['patientName'] = patientName;
    patientMap['patientAge'] = patientAge;
    patientMap['patientCountry'] = patientCountry;
    patientMap['patientCity'] = patientCity;
    patientMap['diseases'] = patientDiseaseList != null || patientDiseaseList?.length != 0 ? patientDiseaseList.toString() : '';
    patientMap['patientDoctors'] = patientsDoctorList != null || patientsDoctorList?.length != 0 ? patientsDoctorList.toString() : '';
    patientMap['patientAlarms'] = patientsAlarms != null || patientsAlarms?.length != 0 ? patientsAlarms.toString() : '';
    patientMap['patientAppointments'] = patientAppointments != null || patientAppointments?.length != 0 ? patientAppointments.toString() : '';
    return patientMap;
  }
}
