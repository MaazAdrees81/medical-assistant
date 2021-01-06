import 'package:patient_assistant_app/models/carousel_model.dart';

class CarouselData {
  List<CarouselModel> _slides = [];

  void _createData() {
//  1
    CarouselModel carouselModel = new CarouselModel();
    carouselModel = new CarouselModel();
    carouselModel.setTitle('Find Specialists');
    carouselModel.setDesc('Search for Specialist and get recommendations based on your Medical Conditions.');
    carouselModel.setSVGName('2_doctors_(1).svg');
    _slides.add(carouselModel);

    //  2
    carouselModel = new CarouselModel();
    carouselModel.setTitle('Get In Touch');
    carouselModel.setDesc('Message your Doctor to schedule an Appointment beforehand.');
    carouselModel.setSVGName('messaging (1).svg');
    _slides.add(carouselModel);

    //  3
    carouselModel = new CarouselModel();
    carouselModel.setTitle('Stay Notified');
    carouselModel.setDesc('Keep track of your Medication and Appointments easily and get notified on time.');
    carouselModel.setSVGName('4_user_interface(1).svg');
    _slides.add(carouselModel);

    //  4
    carouselModel = new CarouselModel();
    carouselModel.setTitle('Cloud Sync');
    carouselModel.setDesc('Sync and save all your data in Cloud Storage to use on other devices.');
    carouselModel.setSVGName('5_cloud_sync(3).svg');
    _slides.add(carouselModel);

//  5
    carouselModel = new CarouselModel();
    carouselModel.setTitle('Location & Directions');
    carouselModel.setDesc('Find nearby Pharmacies and Directions for Hospitals and Clinics.');
    carouselModel.setSVGName('6_pharmacies(1).svg');
    _slides.add(carouselModel);

//  6
    carouselModel = new CarouselModel();
    carouselModel.setTitle('Drug Info');
    carouselModel.setDesc('Search Drugs for their uses, side effects and their interaction with other drugs.');
    carouselModel.setSVGName('7_drugs_info.svg');
    _slides.add(carouselModel);

//  7
    carouselModel = new CarouselModel();
    carouselModel.setTitle('All Right!');
    carouselModel.setDesc('Everything is set. Lets get started now.');
    carouselModel.setSVGName('1_hi_there(1).svg');
    _slides.add(carouselModel);
  }

  List<CarouselModel> getSlides() {
    _createData();
    List<CarouselModel> slidesData = _slides;
    return slidesData;
  }
}
