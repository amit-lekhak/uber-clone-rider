import "package:flutter/material.dart";
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/configMaps.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName;
    pickUpTextEditingController.text = placeAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 250.0,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "Set Drop Off",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              // hintText: "PickUp Location",
                              // textController: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText: "PickUp Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) =>
                              //           MapBoxAutoCompleteWidget(
                              //         apiKey: mapBoxKey,
                              //         hint: "PickUp Location",
                              //         onSelect: (place) {
                              //           print("place ${place.placeName}");
                              //           pickUpTextEditingController.text =
                              //               place.placeName;
                              //         },
                              //         limit: 10,
                              //       ),
                              //     ),
                              //   );
                              // },
                              // enabled: true,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: CustomTextField(
                              hintText: "Where to?",

                              textController: dropOffTextEditingController,
                              // decoration: InputDecoration(
                              //   hintText: "PickUp Location",
                              //   fillColor: Colors.grey[400],
                              //   filled: true,
                              //   border: InputBorder.none,
                              //   isDense: true,
                              //   contentPadding: EdgeInsets.only(
                              //       left: 11.0, top: 8.0, bottom: 8.0),
                              // ),
                              onTap: () async {
                                 await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MapBoxAutoCompleteWidget(
                                      apiKey: mapBoxKey,
                                      hint: "Where to?",
                                      country: "NP",
                                      onSelect: (place) {
                                        dropOffTextEditingController.text =
                                            place.placeName;
                                        setAddressData(place, context);
                                        Navigator.pop(context);
                                      },
                                      limit: 10,
                                    ),
                                  ),
                                );
                              },
                              enabled: true,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void setAddressData(MapBoxPlace place, context) {
    Address address = Address();
    address.placeName = place.placeName;
    address.placeId = place.id;
    address.latitude = place.center[1];
    address.longitude = place.center[0];

    Provider.of<AppData>(context, listen: false)
        .updateDropOffLocationAddress(address);

  }
}
