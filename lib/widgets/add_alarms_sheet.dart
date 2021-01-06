import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:patient_assistant_app/constants.dart';

class AddAlarmsSheet extends StatefulWidget {
  @override
  _AddAlarmsSheetState createState() => _AddAlarmsSheetState();
}

class _AddAlarmsSheetState extends State<AddAlarmsSheet> {
  List<int> weekDays = [];
  String repeatText = 'None';
  String alarmMessage = '';
  DateTime alarmStartingTime = DateTime.now().add(Duration(minutes: 1));
  int hour;
  int minute;

  Widget weekDayTab({String wdText, int wdNum}) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
          onTap: () {
            setState(() {
              weekDays.contains(wdNum) ? weekDays.remove(wdNum) : weekDays.add(wdNum);
              if (weekDays.length == 0) {
                repeatText = 'None';
              } else if (weekDays.length < 7) {
                repeatText = 'Selected Days';
              } else if (weekDays.length == 7) {
                repeatText = 'Everyday';
              }
            });
          },
          child: Container(
              height: 50,
              width: 40,
              child: Center(
                child: Text(
                  wdText,
                  style: TextStyle(
                      color: weekDays.contains(wdNum) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      fontFamily: 'Montserrat'),
                ),
              ),
              decoration: weekDays.contains(wdNum)
                  ? kSelectedFormDecoration.copyWith(
                      color: kappColor1,
                      gradient: LinearGradient(
                          colors: [Color(0xff57D583), Color(0xff46A98C)], //Color(0xb838ef7d)
                          end: Alignment.centerRight,
                          begin: Alignment.topLeft))
                  : kUnselectedFormDecoration)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Add Message:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: TextField(
                  style: TextStyle(height: 1.5, color: kappColor1, fontSize: 19, fontWeight: FontWeight.w500),
                  cursorColor: kappColor1.withAlpha(150),
                  cursorWidth: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  onChanged: (String value) {
                    setState(() {
                      if (value != null && value != '') {
                        alarmMessage = 'Medical Assistant: ' + value;
                      }
                    });
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'e.g. Evening Medication',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    isCollapsed: true,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    'Select Time:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TimePickerSpinner(
                  is24HourMode: false,
                  spacing: 15,
                  itemHeight: 40,
                  highlightedTextStyle: TextStyle(color: kappColor1, fontSize: 35, fontFamily: 'Spartan', fontWeight: FontWeight.w600),
                  normalTextStyle: TextStyle(color: Colors.blueGrey, fontSize: 20, fontFamily: 'Spartan'),
                  time: DateTime.now().add(Duration(minutes: 1, seconds: 10)),
                  onTimeChange: (DateTime time) {
                    if (time.isAfter(DateTime.now())) {
                      setState(() {
                        hour = time.hour;
                        minute = time.minute;
                      });
                    } else {
                      setState(() {
                        alarmStartingTime = DateTime.now().add(Duration(minutes: 1, seconds: 10));
                        hour = alarmStartingTime.hour;
                        minute = alarmStartingTime.minute;
                      });
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Repeat:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    repeatText,
                    style: TextStyle(fontSize: 17, color: kappColor1),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weekDayTab(wdText: 'Mon', wdNum: 2),
                  weekDayTab(wdText: 'Tue', wdNum: 3),
                  weekDayTab(wdText: 'Wed', wdNum: 4),
                  weekDayTab(wdText: 'Thu', wdNum: 5),
                  weekDayTab(wdText: 'Fri', wdNum: 6),
                  weekDayTab(wdText: 'Sat', wdNum: 7),
                  weekDayTab(wdText: 'Sun', wdNum: 1),
                ],
              ),
              SizedBox(
                height: 55,
              ),
              GestureDetector(
                onTap: () {
                  AndroidIntent intent = AndroidIntent(
                    action: 'android.intent.action.SET_ALARM',
                    arguments: {
                      'android.intent.extra.alarm.DAYS': weekDays,
                      'android.intent.extra.alarm.HOUR': hour,
                      'android.intent.extra.alarm.MINUTES': minute,
                      'android.intent.extra.alarm.SKIP_UI': true,
                      'android.intent.extra.alarm.MESSAGE': alarmMessage,
                    },
                  );
                  intent.launch();
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 40,
                  width: 80,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  decoration: kGetStartedButton,
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
