import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/Models/allUsers.dart';
import 'package:rider_app/Models/directionDetails.dart';
import "package:rider_app/configMaps.dart";
import "package:http/http.dart" as http;

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
    var distanceinKm = (distance / 1000).toStringAsFixed(2);

    directionDetails.distanceText = "$distanceinKm km";
    directionDetails.distanceValue = distance;

    directionDetails.durationText =
        "${res["routes"][0]["legs"][0]["duration"]} s";
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    double timeTravelledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelledFare =
        (directionDetails.distanceValue / 1000) * 0.20;

    double totalFareAmount = timeTravelledFare + distanceTravelledFare;

    return totalFareAmount.truncate();
  }

  static void getCurrentUserInfo() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userCurrentInfo = Users.fromSnapShot(dataSnapshot);
      }
    });
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }

  static sendNotificationToDriver(
      String token, context, String rideRequestId) async {
    var destination =
        Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map<String, String> headerMap = {
      "Content-Type": "application/json",
      "Authorization": serverToken
    };

    Map notificationMap = {
      "body": "DropOff Address, ${destination.placeName}",
      "title": "New Ride Request"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "ride_request_id": rideRequestId,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token
    };

    var res = await http.post("https://fcm.googleapis.com/fcm/send",
        headers: headerMap, body: jsonEncode(sendNotificationMap));
  }
}
