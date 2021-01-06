class CarouselModel {
  String title;
  String desc;
  String svgName;

  void setTitle(String slideTitle) {
    title = slideTitle;
  }

  void setDesc(String slideDesc) {
    desc = slideDesc;
  }

  void setSVGName(String slideSVGName) {
    svgName = slideSVGName;
  }

  String getTitle() => title;
  String getDesc() => desc;
  String getSVGName() => svgName;
}
