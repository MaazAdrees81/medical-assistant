import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/utils/db_helper.dart';
import 'package:patient_assistant_app/utils/utils.dart';

class FirestoreHandler {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> checkIdForUserFirestore({String id, dynamic user}) async {
    Patient patient;
    Doctor doctor;
    if (id != null) {
      patient = await getPatientFirestore(id);
      doctor = await getDoctorFirestore(id);
    } else {
      user.runtimeType == Patient ? patient = await getPatientFirestore(user.patientID) : patient = null;
      user.runtimeType == Doctor ? doctor = await getDoctorFirestore(user.doctorID) : doctor = null;
    }
    if (doctor == null && patient == null) {
      return null;
    } else if (doctor != null) {
      return doctor;
    } else if (patient != null) {
      return patient;
    }
  }

//  if the data has not been stored in Firestore
  Future<void> pushDataToFirestore(dynamic user) async {
    if (user.runtimeType == Patient) {
      savePatientFirestore(user);
    } else if (user.runtimeType == Doctor) {
      saveDoctorFirestore(user);
    }
  }

//                  Patient Operations
  Future<void> savePatientFirestore(Patient patient) async {
    CollectionReference patientsRef = _firestore.collection('patients');
    await patientsRef.doc(patient.patientID).set(patient.toMap());
  }

  Future<Patient> getPatientFirestore(String patientID) async {
    CollectionReference patientsRef = _firestore.collection('patients');
    DocumentSnapshot patient = await patientsRef.doc(patientID).get();
    return patient.data() != null ? Patient.fromMap(patient.data()) : null;
  }

  Future<List<Patient>> getPatients() async {
    List<Patient> patients = [];
    CollectionReference patientsRef = _firestore.collection('patients');
    QuerySnapshot patient = await patientsRef.get();
    patient.docs.forEach((element) {
      patients.add(Patient.fromMap(element.data()));
    });
    return patients;
  }

//                  Doctor Operations
  Future<void> saveDoctorFirestore(Doctor doctor) async {
    CollectionReference doctorsRef = _firestore.collection('doctors');
    await doctorsRef.doc(doctor.doctorID).set(doctor.toMap());
  }

  Future<Doctor> getDoctorFirestore(String doctorID) async {
    CollectionReference doctorsRef = _firestore.collection('doctors');
    DocumentSnapshot doctor = await doctorsRef.doc(doctorID).get();
    return doctor.data() != null ? Doctor.fromMap(doctor.data()) : null;
  }

  Future<List<Doctor>> getDoctors() async {
    List<Doctor> doctors = [];
    CollectionReference doctorsRef = _firestore.collection('doctors');
    QuerySnapshot doctor = await doctorsRef.get();
    doctor.docs.forEach((element) {
      doctors.add(Doctor.fromMap(element.data()));
    });
    return doctors;
  }

//                 Message Operations

  /// Returns List of UserChats with messages string as Message Object
  Future<List<Map<String, dynamic>>> getUserMessagesFirestore(String userID) async {
    CollectionReference messagesRef = _firestore.collection('messages');
    QuerySnapshot userMessages = await messagesRef.get();
    List<Map<String, dynamic>> userChat = [];
    userMessages.docs.forEach((document) {
      if (document.id.contains(userID)) {
        userChat.add(decodeChat(document.data()));
      }
    });
    return userChat;
  }

  Future<void> downloadUserChat(String userID) async {
    CollectionReference messagesRef = _firestore.collection('messages');
    QuerySnapshot userMessages = await messagesRef.get();
    for (DocumentSnapshot document in userMessages.docs) {
      if (document.id.contains(userID)) {
        await DBHelper().insertMessagesDB(chatID: document.data()['chatID'], messages: document.data()['messages']);
      }
    }
  }
}
