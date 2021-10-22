import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:restaurantfinder/api/place_api.dart';
import 'package:restaurantfinder/constants.dart';
import 'package:restaurantfinder/models/restaurant.dart';
import 'package:restaurantfinder/widgets/custom_textfield.dart';
import 'package:restaurantfinder/widgets/progress_button.dart';
import 'package:restaurantfinder/widgets/restaurant_tile.dart';

class NearbyScreen extends StatefulWidget {
  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  List<Restaurant>? restaurants;

  bool fetching = false;
  bool? permissionGranted;

  Location location = new Location();
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  void fetchRestaurants() async {
    // PlaceApi.getNearbyRestaurants(userLocation)
  }

  Future<bool> requestLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> listenForUserLocation() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    userLocation = LatLng(_locationData.latitude!, _locationData.longitude!);
    location.onLocationChanged.listen((LocationData currentLocation) {
      userLocation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: double.infinity,
          color: kPrimaryColor,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: kPrimaryColorLight,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: CustomTextField(
                        hintText: "Search for restaurants",
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  permissionGranted == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "images/restaurant.svg",
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 40, bottom: 30, top: 30),
                                child: Text(
                                  "Grant location permission to continue",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              ProgressButton(
                                height: 50,
                                width: 200,
                                text: "Grant permission",
                                onTap: () async {
                                  bool accepted =
                                      await requestLocationPermission();
                                  if (accepted) {
                                    await listenForUserLocation();
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      : Expanded(
                          child: Column(
                          children: [
                            Text(
                              "Restaurants near you",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Expanded(
                                child: restaurants==null&&fetching==false?:ListView(
                              padding: EdgeInsets.zero,
                              children: [RestaurantTile()],
                            ))
                          ],
                        ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
