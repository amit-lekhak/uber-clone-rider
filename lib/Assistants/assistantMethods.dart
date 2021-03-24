import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/Models/directionDetails.dart';
import "package:rider_app/configMaps.dart";

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    // String st1, st2, st3, st4;
    String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${position.longitude},${position.latitude}.json?access_token=$mapBoxKey";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["features"][0]["place_name"];

      // st1 = response["features"][0]["context"][2]["text"];
      // st2 = response["features"][0]["context"][4]["text"];
      // st3 = response["features"][0]["context"][5]["text"];
      // st4 = response["features"][0]["context"][6]["text"];

      // placeAddress = "$st1, $st2, $st3, $st4";

      Address userPickUpAddress = new Address();
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://api.mapbox.com/directions/v5/mapbox/driving/${initialPosition.longitude},${initialPosition.latitude};${finalPosition.longitude},${finalPosition.latitude}?access_token=$mapBoxKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") return null;

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["geometry"];

    double distance = res["routes"][0]["legs"][0]["distance"];
    var distanceinMiles = distance * 0.000621371192;

    directionDetails.distanceText = "$distanceinMiles mi";
    directionDetails.distanceValue = distance;

    directionDetails.durationText =
        "${res["routes"][0]["legs"][0]["duration"]} s";
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"];

    return directionDetails;
  }
}
