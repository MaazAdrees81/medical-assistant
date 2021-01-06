import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageHelper {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://patient-assistant-app.appspot.com');

  Future<void> checkImageIsPresent(String userID) async {
    File image = await getLocalProfileImage(userID: userID);
    if (image == null) {
      image = await downloadProfileImage(userID: userID);
      if (image != null) {
        await saveImageLocally(userID: userID, image: image);
      }
    }
  }

  Future<File> getLocalProfileImage({String userID}) async {
    Directory appDir = await getExternalStorageDirectory();
    String filePath = appDir.path + '/images/$userID.jpg';
    File temp;
    if (File.fromUri(Uri.parse(filePath)).existsSync()) {
      temp = File.fromUri(Uri.parse(filePath));
    } else {
      temp = null;
    }
    return temp;
  }

  Future<void> saveImageLocally({String userID, File image}) async {
    Directory appDir = await getExternalStorageDirectory();
    String filePath = appDir.path + '/images/$userID.jpg';
    Directory('${appDir.path}/images/').createSync(recursive: true);
    File temp = File(filePath);
    temp.writeAsBytesSync(image.readAsBytesSync());
  }

  Future<File> downloadProfileImage({String userID}) async {
    Directory appDir = await getExternalStorageDirectory();
    Directory('${appDir.path}/images/').createSync(recursive: true);
    String filePath = appDir.path + '/images/$userID.jpg';
    File profileImage = File(filePath);
    try {
      String imageUrl = await _storage.ref().child(userID + '.jpg').getDownloadURL();
      Response response = await get(imageUrl);
      profileImage.writeAsBytesSync(response.bodyBytes);
    } catch (e) {
      profileImage = null;
    }
    return profileImage;
  }

  Future<void> uploadProfileImage({String userID, File image}) async {
    if (image != null) {
      String fileName = userID + '.jpg';
      _storage.ref().child(fileName).putFile(image);
    }
  }
}
