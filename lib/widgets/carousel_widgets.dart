import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';

Widget pageIndicatorCircle(bool isCurrent) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4),
    height: isCurrent ? 9 : 6,
    width: isCurrent ? 9 : 6,
    decoration: BoxDecoration(
      color: isCurrent ? kappColor1 : Colors.green.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

/*        {carouselBottomSheet}       */
class CarouselBottomSheet extends StatelessWidget {
  CarouselBottomSheet({
    Key key,
    @required this.pageController,
    @required this.slides,
    @required this.currentSlideIndex,
  }) : super(key: key);

  final PageController pageController;
  final List slides;
  final int currentSlideIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: currentSlideIndex == slides.length - 1
                ? null
                : () {
                    pageController.animateToPage(slides.length - 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                  },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text('Skip', style: kbottomSheetButton),
            ),
          ),
          InkWell(
            onTap: currentSlideIndex == slides.length - 1
                ? null
                : () {
                    pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                  },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text('Next', style: kbottomSheetButton),
            ),
          ),
        ],
      ),
    );
  }
}
