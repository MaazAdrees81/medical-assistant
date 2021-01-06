import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';

class CarouselTile extends StatelessWidget {
  CarouselTile({this.svgName, this.desc, this.title, this.currentSlideIndex, this.slidesLength});

  final String svgName;
  final String title;
  final String desc;
  final int slidesLength;
  final int currentSlideIndex;
  final _assets = 'assets/images/';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: kslideTitle,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: kslideDesc,
          ),
        ),
        SvgPicture.asset(
          '$_assets$svgName',
          height: MediaQuery.of(context).size.height / 3,
          width: 270,
        ),
      ],
    );
  }
}
