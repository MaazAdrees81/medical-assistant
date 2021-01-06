import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';

class FeatureContainer extends StatelessWidget {
  FeatureContainer({this.heading, this.description, this.assetName, this.color, this.onTap, this.padding});
  final String heading;
  final String description;
  final String assetName;
  final Color color;
  final Function onTap;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.13,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withAlpha(50)),
        ),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.only(left: 15),
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: color,
              ),
              child: SvgPicture.asset(
                'assets/images/$assetName',
                color: Colors.white,
                height: 20,
                width: 20,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: kmainHeadingColor1, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 5),
                      child: Text(
                        description,
                        style: kdescriptionStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.arrow_forward_ios, size: 20, color: kappColor.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }
}
