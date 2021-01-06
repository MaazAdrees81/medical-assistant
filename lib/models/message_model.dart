class Message {
  Message({this.sender, this.receiver, this.receiverName, this.senderName, this.message, this.dateTime});

  Message.fromMap(Map map) {
    if (map != null) {
      this.sender = map['sender'];
      this.senderName = map['senderName'];
      this.receiver = map['receiver'];
      this.receiverName = map['receiverName'];
      this.message = map['message'];
      this.dateTime = DateTime.parse(map['dateTime']);
    }
  }

  String sender;
  String senderName;
  String receiver;
  String receiverName;
  String message;
  DateTime dateTime;

  Map<String, dynamic> topMap() {
    Map<String, dynamic> messageMap = {};
    messageMap['sender'] = sender;
    messageMap['senderName'] = senderName;
    messageMap['receiver'] = receiver;
    messageMap['receiverName'] = receiverName;
    messageMap['message'] = message;
    messageMap['dateTime'] = dateTime.toString();
    return messageMap;
  }
}
