import 'package:rider_app/Models/nearByAvailableDrivers.dart';

class GeoFireAssistant {
  static List<NearByAvailableDrivers> nearByAvailableDriversList = [];

  static void removeDriverFromList(String key) {
    int index =
        nearByAvailableDriversList.indexWhere((element) => element.key == key);
    nearByAvailableDriversList.removeAt(index);
  }

  static void updateDriverNearByLocation(NearByAvailableDrivers driver) {
    int index = nearByAvailableDriversList
        .indexWhere((element) => element.key == driver.key);
    nearByAvailableDriversList[index].latitude = driver.latitude;
    nearByAvailableDriversList[index].longitude = driver.longitude;
  }
}
