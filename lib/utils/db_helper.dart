import 'package:path/path.dart';
import 'package:patient_assistant_app/models/doctor_model.dart';
import 'package:patient_assistant_app/models/patient_model.dart';
import 'package:patient_assistant_app/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database _database;

  Future<String> databasePath() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return path;
  }

  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS Patients');
    batch.execute(
        "CREATE TABLE Patients (patientID TEXT PRIMARY KEY,patientName TEXT,patientAge TEXT,patientCountry TEXT,patientCity TEXT,diseases TEXT,patientDoctors TEXT,patientAlarms TEXT,patientAppointments TEXT)");
    batch.delete('Patients');
    batch.execute('DROP TABLE IF EXISTS Doctors');
    batch.execute(
        "CREATE TABLE Doctors (doctorID TEXT PRIMARY KEY,doctorName TEXT,doctorPhoneNo TEXT,doctorCountry TEXT,doctorCity TEXT,practiceType TEXT,specialties TEXT,doctorExperience TEXT,doctorAppointmentFee TEXT,doctorsWorkplaceName TEXT,doctorsWorkplaceAddress TEXT,doctorsPatients TEXT,doctorsAppointments TEXT)");
    batch.delete('Doctors');
    batch.execute("CREATE TABLE Messages (chatID TEXT PRIMARY KEY,messages TEXT)");
    await batch.commit();
  }

  Future<void> openDB() async {
    _database = await openDatabase(
      await databasePath(),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> deleteTables() async {
    await _database.delete('Patients');
    await _database.delete('Doctors');
    await _database.delete('Messages');
    await _database.execute('DROP TABLE Patients');
    await _database.execute('DROP TABLE Doctors');
    await _database.execute('DROP TABLE Messages');
  }

  Future<List<String>> getTableNames() async {
    var tableNames = (await _database.query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false)
          ..sort();
    return tableNames;
  }

  Future<dynamic> checkIDForUserDatabase(String id) async {
    await openDB();
    Doctor doctor = await readDoctorData(id);
    Patient patient = await readPatientData(id);
    if (doctor == null && patient == null) {
      return null;
    } else if (doctor != null && doctor.doctorID == id) {
      return doctor;
    } else if (patient != null && patient.patientID == id) {
      return patient;
    }
  }

//                [Patient Operations]
  Future<void> insertPatientDB(Patient patient) async {
    await openDB();
    await _database.insert('Patients', patient.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Patient> readPatientData(String patientID) async {
    await openDB();
    List<Map<String, dynamic>> maps = await _database.query('Patients', where: 'patientID = ?', whereArgs: [patientID], distinct: true);
    return maps.length != 0 ? Patient.fromMap(maps[0]) : null;
  }

  Future<List<Patient>> readAllPatients() async {
    await openDB();
    List<Patient> patientsList = [];
    List<Map<String, dynamic>> maps = await _database.query('Patients');
    maps.forEach((element) {
      patientsList.add(Patient.fromMap(element));
    });
    return patientsList;
  }

  //                [Doctor Operations]
  Future<void> insertDoctorDB(Doctor doctor) async {
    await openDB();
    await _database.insert('Doctors', doctor.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Doctor> readDoctorData(String doctorID) async {
    await openDB();
    List<Map<String, dynamic>> maps = await _database.query('Doctors', where: 'doctorID = ?', whereArgs: [doctorID], distinct: true);
    return maps.length != 0 ? Doctor.fromMap(maps[0]) : null;
  }

  Future<List<Doctor>> readAllDoctors() async {
    await openDB();
    List<Doctor> doctorsList = [];
    List<Map<String, dynamic>> maps = await _database.query('Doctors');
    maps.forEach((element) {
      doctorsList.add(Doctor.fromMap(element));
    });
    return doctorsList;
  }

//                     [Messages Operations]

  Future<List<Map<String, dynamic>>> readUserChatDB(String userID) async {
    await openDB();
    List<Map<String, dynamic>> userChat = [];
    List<Map<String, dynamic>> chatsList = await _database.query('Messages');
    if (chatsList.length != 0) {
      chatsList.forEach((chat) {
        String chatID = chat['chatID'];
        if (chatID.contains(userID)) {
          userChat.add(chat);
        }
      });
    }
    return userChat;
  }

  Future<void> insertUserChatDB({List<Map<String, dynamic>> chats}) async {
    await openDB();
    for (Map<String, dynamic> chat in chats) {
      Map<String, dynamic> encodedChat = encodeChat(chat);
      await _database.insert(
          'Messages',
          {
            'chatID': encodedChat['chatID'],
            'messages': encodedChat['messages'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  /// Takes String chatID and List of Message.toMap objects as jsonEncoded String
  Future<void> insertMessagesDB({String chatID, String messages}) async {
    await openDB();
    await _database.insert('Messages', {'chatID': chatID, 'messages': messages}, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
