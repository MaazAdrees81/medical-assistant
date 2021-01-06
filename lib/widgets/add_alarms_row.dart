import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/widgets/add_alarms_sheet.dart';

class AddAlarmRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Row(
        children: [
          Icon(Icons.alarm_add, size: MediaQuery.of(context).size.height * 0.06, color: kmainHeadingColor1.withAlpha(200)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Alarms',
                      style: TextStyle(fontSize: 20, fontFamily: 'Montserrat', color: kmainHeadingColor1.withAlpha(200), fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Add Reminders for your Medications or Appointments',
                    style: kdescriptionStyle,
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(30),
              splashColor: kappColor1,
              highlightColor: kappColor1,
              onTap: () async {
                AndroidIntent intent = AndroidIntent(
                  action: 'android.intent.action.SET_ALARM',
                );
                //check if there is an app to resolve this intent (add alarms)
                if (await intent.canResolveActivity()) {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      context: context,
                      builder: (context) => AddAlarmsSheet());
                } else {
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Color(0xff2f9f8f),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      content: Row(
                        children: [
                          Icon(Icons.not_interested, color: Colors.white, size: 25),
                          SizedBox(width: 10),
                          Text('No app found that can complete this actions',
                              textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      )));
                }
              },
              child: Container(
                height: 30,
                width: 50,
                child: Center(
                    child: Text(
                  'add',
                  style: TextStyle(color: kappColor1, fontWeight: FontWeight.bold),
                )),
                decoration: BoxDecoration(
                  border: Border.all(color: kappColor1.withAlpha(200), width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
