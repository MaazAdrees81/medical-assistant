import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';

class DiseaseDetailScreen extends StatelessWidget {
  DiseaseDetailScreen({this.diseaseDetail});
  final BoxDecoration headingDecoration = BoxDecoration(
    gradient: ksearchScreenGradient,
    borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
  );
  final TextStyle categoryStyle = TextStyle(fontSize: 23, color: kmainHeadingColor1, fontWeight: FontWeight.w300);
  final TextStyle headingStyle = TextStyle(fontSize: 23, color: Colors.white, fontFamily: 'Montserrat');
  final TextStyle descriptionStyle = TextStyle(fontSize: 17, letterSpacing: 0.2, height: 1.5, color: kdarkTextColor);
  final Map<String, dynamic> diseaseDetail;

  List<Widget> categoryView(BuildContext context) {
    List<Widget> categories = [];
    for (String category in diseaseDetail['disease_cat'].split(', ')) {
      categories.add(
        Padding(
          padding: EdgeInsets.all(4),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(30),
              splashColor: kmainHeadingColor1,
              highlightColor: Colors.white,
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: kmainHeadingColor1.withAlpha(150), width: 0.5),
                ),
                child: Text(
                  category,
                  style: TextStyle(color: kmainHeadingColor1, fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 15, left: 15, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${diseaseDetail['disease_name']}',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: kmainHeadingColor1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: <Widget>[
                  Divider(
                    indent: 30,
                    endIndent: MediaQuery.of(context).size.width / 3.7,
                    thickness: 0.4,
                    color: Colors.grey.shade400,
                  ),
                  Center(
                      child: Text('Details',
                          style: TextStyle(
                            fontSize: 28,
                            color: kappColor1,
                            // fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w300,
                          ))),
                  Divider(
                    indent: MediaQuery.of(context).size.width / 3.7,
                    thickness: 0.4,
                    color: Colors.grey.shade400,
                    endIndent: 30,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                margin: EdgeInsets.only(top: 20, bottom: 20),
                decoration: headingDecoration,
                child: Text('Disease Category:', style: headingStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: diseaseDetail['disease_cat'].isNotEmpty
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        children: categoryView(context),
                      )
                    : Text('\"NA\"', textAlign: TextAlign.center, style: categoryStyle),
              ),
              Container(
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                margin: EdgeInsets.only(top: 20, bottom: 20),
                decoration: headingDecoration,
                child: Text('Disease Info:', style: headingStyle),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  diseaseDetail['disease_info'],
                  style: descriptionStyle,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
