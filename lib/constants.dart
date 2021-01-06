import 'package:flutter/material.dart';

//                                COLORS and Gradient

Color kprimaryColor = Color(0xff55D24A);
Color kappColor = Color(0xff31e06C);
Color kappColor1 = Color(0xff01CF85);
Color kmainHeadingColor1 = Color(0xff035290);
Color kmainHeadingColor2 = Color(0xff4749A0);
Color kheadingColor2 = Color(0xff00A3A8);
Color ksecondaryColor = Color(0xff0CC3C8);
Color kerrorColor = Color(0xfff75010);
Color kdarkTextColor = Color(0xff2C385B);

//                                 TextStyles

TextStyle kslideTitle = TextStyle(
  color: kmainHeadingColor1,
  fontSize: 25,
  fontWeight: FontWeight.w500,
);

TextStyle kslideDesc = TextStyle(
  color: kheadingColor2,
  letterSpacing: 1,
  fontSize: 15,
  height: 1.2,
);

TextStyle kbottomSheetButton = TextStyle(
  color: kmainHeadingColor1,
  fontSize: 14,
);

TextStyle kgetStartedBtn = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 15,
);

TextStyle kloginBtn = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 17,
);

TextStyle kdialogTitleStyle = TextStyle(
  color: kmainHeadingColor1,
  fontSize: 30,
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w600,
);

TextStyle kdialogContentStyle = TextStyle(
  fontWeight: FontWeight.w400,
  height: 1.5,
  wordSpacing: -0.2,
  letterSpacing: -0.1,
  color: Colors.black.withAlpha(180),
  fontSize: 18,
);

TextStyle kprocessInfoStyle = TextStyle(
  color: Colors.blueGrey,
  fontWeight: FontWeight.bold,
  fontSize: 13,
);

TextStyle kdescriptionStyle = TextStyle(fontSize: 14, color: Colors.grey);

TextStyle kalertDescriptionStyle = TextStyle(fontSize: 16, letterSpacing: 0.2, height: 1.4, color: Colors.blueGrey);

//                          Gradients

LinearGradient ksearchScreenGradient = LinearGradient(
  colors: [Color(0xff57D583), Color(0xff46A98C)],
  end: Alignment.centerRight,
  begin: Alignment.topLeft,
);

LinearGradient kfeatureGradient = LinearGradient(
  colors: [Colors.lightGreen.withAlpha(190), Color(0xff329D9C).withAlpha(190)],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);

LinearGradient kgetStartedGradient = LinearGradient(
  colors: [Color(0xa011998e), Color(0xff38ef7d)],
  begin: Alignment.bottomRight,
  end: Alignment.centerLeft,
);

//                          Box Decorations

BoxDecoration kGetStartedButton = BoxDecoration(
  color: kprimaryColor,
  gradient: kgetStartedGradient,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 2),
      color: Colors.black12,
      blurRadius: 2,
    ),
    BoxShadow(
      offset: Offset(2, 2),
      color: Colors.black12,
      blurRadius: 2,
    ),
    BoxShadow(
      offset: Offset(-2, 2),
      color: Colors.black12,
      blurRadius: 2,
    ),
  ],
);

BoxDecoration kAlertBtnDecoration = BoxDecoration(
  shape: BoxShape.circle,
  gradient: LinearGradient(
    colors: [Color(0xff11998e), Color(0xff38ef7d)],
    begin: Alignment.bottomRight,
    end: Alignment.centerLeft,
  ),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 2),
      color: Colors.black12,
      blurRadius: 2,
    ),
    BoxShadow(
      offset: Offset(2, 2),
      color: Colors.black12,
      blurRadius: 2,
    ),
    BoxShadow(
      offset: Offset(-2, 2),
      color: Colors.black12,
      blurRadius: 2,
    ),
  ],
);

BoxDecoration kSelectedFormDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xff13547a), kheadingColor2],
  ),
  color: Colors.white70,
  borderRadius: BorderRadius.circular(10),
);

BoxDecoration kUnselectedFormDecoration = BoxDecoration(
  border: Border.all(color: Colors.blueGrey.withAlpha(140), width: 1),
  borderRadius: BorderRadius.circular(10),
);

BoxDecoration ktextFieldDecoration = BoxDecoration(boxShadow: [
  BoxShadow(
    color: kmainHeadingColor1.withAlpha(120),
    offset: Offset(0, 2),
    blurRadius: 7,
    spreadRadius: -18,
  ),
]);

BoxDecoration ksmallFieldDecoration = BoxDecoration(boxShadow: [
  BoxShadow(
    color: kmainHeadingColor1.withAlpha(120),
    offset: Offset(0, 8),
    blurRadius: 7,
    spreadRadius: -18,
  ),
]);

BoxDecoration ksenderMessageDecoration = BoxDecoration(
  gradient: ksearchScreenGradient,
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
    topLeft: Radius.circular(30),
    bottomLeft: Radius.circular(30),
  ),
);
BoxDecoration kreceiverMessageDecoration = BoxDecoration(
  color: Color(0xFFF3FDFD),
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
    bottomRight: Radius.circular(30),
    topLeft: Radius.circular(30),
  ),
);

//                  InputDecorations

InputDecoration chatTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
    hintText: 'Type message here',
    hintStyle: TextStyle(fontSize: 17, fontFamily: 'Montserrat', color: kmainHeadingColor1.withAlpha(100)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kmainHeadingColor1.withAlpha(150), width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kmainHeadingColor1.withAlpha(40), width: 1),
      borderRadius: BorderRadius.circular(20),
    ));
