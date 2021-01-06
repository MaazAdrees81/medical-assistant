import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_assistant_app/constants.dart';
import 'package:patient_assistant_app/data/carousel_data.dart';
import 'package:patient_assistant_app/screens/login_sing_up_screen.dart';
import 'package:patient_assistant_app/widgets/carousel_tile.dart';
import 'package:patient_assistant_app/widgets/carousel_widgets.dart';

class WelcomeCarousel extends StatefulWidget {
  @override
  _WelcomeCarouselState createState() => _WelcomeCarouselState();
}

class _WelcomeCarouselState extends State<WelcomeCarousel> with TickerProviderStateMixin {
  PageController _pageController;
  AnimationController _getStartedAnimController;
  AnimationController _bottomSheetAnimController;
  CarouselData data;
  List slides;
  int currentSlideIndex = 0;
  Animation getStartedAnim;
  Animation bottomSheetAnim;

  @override
  void initState() {
    _pageController = PageController();
    data = CarouselData();
    slides = data.getSlides();
    _getStartedAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
      reverseDuration: Duration(milliseconds: 400),
    );
    _bottomSheetAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    getStartedAnim = Tween(begin: 0.0, end: 1.0).animate(_getStartedAnimController);
    super.initState();
    bottomSheetAnim = Tween(begin: 1.0, end: 0.0).animate(_bottomSheetAnimController);
    super.initState();
  }

  @override
  void dispose() {
    _bottomSheetAnimController.dispose();
    _getStartedAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget getStartedButton() {
    return FadeTransition(
      opacity: getStartedAnim,
      child: InkWell(
        splashColor: Colors.white,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        onTap: currentSlideIndex != slides.length - 1
            ? null
            : () {
                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => LoginSignUpScreen()));
              },
        child: Container(
          height: 40,
          width: 110,
          decoration: kGetStartedButton,
          child: Center(
            child: Text(
              'Get Started',
              style: kloginBtn,
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return FadeTransition(
      opacity: bottomSheetAnim,
      child: CarouselBottomSheet(
        pageController: _pageController,
        slides: slides,
        currentSlideIndex: currentSlideIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SvgPicture.asset(
                'assets/images/app_logo.svg',
                height: 60,
              ),
            ),
            Expanded(
              flex: 8,
              child: PageView.builder(
                allowImplicitScrolling: false,
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  return CarouselTile(
                    title: slides[index].getTitle(),
                    desc: slides[index].getDesc(),
                    svgName: slides[index].getSVGName(),
                    currentSlideIndex: currentSlideIndex,
                    slidesLength: slides.length,
                  );
                },
                onPageChanged: (val) {
                  setState(() {
                    currentSlideIndex = val;
                    if (currentSlideIndex == slides.length - 1) {
                      _getStartedAnimController.forward();
                      _bottomSheetAnimController.forward();
                    }
                    if ((currentSlideIndex != slides.length - 1) && _getStartedAnimController.status == AnimationStatus.completed) {
                      _getStartedAnimController.reverse();
                      _bottomSheetAnimController.reverse();
                    }
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < slides.length; i++) currentSlideIndex == i ? pageIndicatorCircle(true) : pageIndicatorCircle(false)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  getStartedButton(),
                ],
              ),
            ),
            bottomSheet(),
          ],
        ),
      ),
    );
  }
}
