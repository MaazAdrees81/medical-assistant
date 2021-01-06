import 'dart:convert';

import 'package:patient_assistant_app/models/message_model.dart';

List stringToList(String data) {
  List<String> dataList = [];
  data = data.replaceAll('[]', '');
  if (data.length != 0) {
    data = data.replaceAll('[', '');
    data = data.replaceAll(']', '');
    dataList = data.split(', ');
  }
  return dataList;
}

List<Map<String, dynamic>> decodeMessagesObjects(List<Map<String, dynamic>> chats) {
  List<Map<String, dynamic>> decodedChats = [];
  for (Map<String, dynamic> chat in chats) {
    List<Message> messageList = [];
    for (dynamic messageMap in jsonDecode(chat['messages'])) {
      messageList.add(Message.fromMap(messageMap));
    }
    Map<String, dynamic> map = {
      'chatID': chat['chatID'],
      'messages': messageList,
    };
    decodedChats.add(map);
  }
  return decodedChats;
}

Map<String, dynamic> decodeChat(Map<String, dynamic> chat) {
  List<Message> messageList = [];
  for (dynamic messageMap in jsonDecode(chat['messages'])) {
    messageList.add(Message.fromMap(messageMap));
  }
  Map<String, dynamic> map = {
    'chatID': chat['chatID'],
    'messages': messageList,
  };
  return map;
}

Map<String, dynamic> encodeChat(Map<String, dynamic> chat) {
  List<Map<String, dynamic>> messageList = [];
  for (Message messageMap in chat['messages']) {
    messageList.add(messageMap.topMap());
  }
  Map<String, dynamic> map = {
    'chatID': chat['chatID'],
    'messages': jsonEncode(messageList),
  };
  return map;
}

List<Map<String, dynamic>> encodeMessagesObjects(List<Map<String, dynamic>> chats) {
  List<Map<String, dynamic>> encodedChats = [];
  for (Map<String, dynamic> chat in chats) {
    List<Map<String, dynamic>> messageList = [];
    for (Message messageMap in chat['messages']) {
      messageList.add(messageMap.topMap());
    }
    Map<String, dynamic> map = {
      'chatID': chat['chatID'],
      'messages': jsonEncode(messageList),
    };
    encodedChats.add(map);
  }
  return encodedChats;
}

String getDateTimeString(DateTime dateTime) {
  String dateTimeString;
  String month;
  String amPM = dateTime.hour > 12 ? 'PM' : 'AM';
  String minutes = dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
  String hours = dateTime.hour % 12 == 0 ? '12' : '${dateTime.hour % 12}';
  String time = '$hours:$minutes';
  DateTime now = DateTime.now();
  if (now.day - dateTime.day == 1 && now.month == dateTime.month && now.year == dateTime.year) {
    dateTimeString = 'Yesterday';
  } else if (now.day - dateTime.day > 1) {
    switch (dateTime.month) {
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Apr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sep';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dec';
        break;
    }
    dateTimeString = now.year == dateTime.year ? '$month ${dateTime.day}' : '$month ${dateTime.day} ${dateTime.year}';
  }
  if (dateTimeString == null) {
    dateTimeString = '$time $amPM';
  }
  return dateTimeString;
}
