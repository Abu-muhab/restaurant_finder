import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:restaurantfinder/api/place_api.dart';
import 'package:restaurantfinder/constants.dart';
import 'package:restaurantfinder/models/restaurant.dart';
import 'package:restaurantfinder/providers/auth_provider.dart';
import 'package:restaurantfinder/widgets/custom_textfield.dart';
import 'package:restaurantfinder/widgets/progress_button.dart';
import 'package:restaurantfinder/widgets/restaurant_tile.dart';

class NearbyScreen extends StatefulWidget {
  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Restaurant>? restaurants;

  bool? fetching;
  bool fetchingNextPage = false;

  bool? permissionGranted;

  Location location = new Location();
  LatLng? userLocation;

  String? nextPageToken;

  late ScrollController scrollController;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      requestLocationPermission().then((value) {
        setState(() {
          permissionGranted = value;
        });
        if (value) {
          listenForUserLocation();
        }
      });
    });
    scrollController = ScrollController();
    scrollController.addListener(() {
      if ((scrollController.position.maxScrollExtent -
              scrollController.position.pixels) <=
          20) {
        fetchNextPage();
      }
    });
    super.initState();
  }

  Future<void> fetchRestaurants({bool isRefresh = false}) async {
    try {
      if (fetching == true) {
        return;
      }
      setState(() {
        fetching = true;
        if (isRefresh == true) {
          this.restaurants = null;
          nextPageToken = null;
        }
      });
      NearbyRestaurantResponse response =
          await PlaceApi.getNearbyRestaurants(userLocation!);
      setState(() {
        this.restaurants = response.restaurants;
        nextPageToken = response.nextPageToken;
        fetching = false;
      });
    } catch (err) {
      print(err.toString());
      setState(() {
        fetching = false;
      });
    }
  }

  Future<void> fetchNextPage() async {
    if (nextPageToken == null ||
        restaurants == null ||
        fetchingNextPage == true) return;
    try {
      setState(() {
        fetchingNextPage = true;
      });
      NearbyRestaurantResponse response = await PlaceApi.getNearbyRestaurants(
          userLocation!,
          pageToken: nextPageToken);
      setState(() {
        this.restaurants!.addAll(response.restaurants);
        nextPageToken = response.nextPageToken;
        fetchingNextPage = false;
      });
    } catch (err) {
      print(err.toString());
      setState(() {
        fetchingNextPage = false;
      });
    }
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
    fetchRestaurants();
    location.onLocationChanged.listen((LocationData currentLocation) {
      userLocation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: kPrimaryColor,
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Provider.of<AuthProvider>(context, listen: false)
                        .logout()
                        .then((value) {
                      if (Navigator.canPop(context)) {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: double.infinity,
          color: kPrimaryColor,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
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
                  permissionGranted == null || permissionGranted == false
                      ? Expanded(
                          child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "images/restaurant.svg",
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                                  setState(() {
                                    permissionGranted = accepted;
                                  });
                                  if (accepted) {
                                    await listenForUserLocation();
                                  }
                                },
                              )
                            ],
                          ),
                        ))
                      : Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Restaurants near you",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                child: fetching == null
                                    ? Center(
                                        child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blueAccent),
                                          strokeWidth: 3,
                                        ),
                                      ))
                                    : restaurants == null && fetching == false
                                        ? Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                  "images/error.svg",
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 40,
                                                      right: 40,
                                                      bottom: 30,
                                                      top: 30),
                                                  child: Text(
                                                    "Error fetching restaurants. Try again",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                  text: "Reload",
                                                  onTap: () async {
                                                    await fetchRestaurants();
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        : restaurants == null &&
                                                fetching == true
                                            ? Center(
                                                child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.blueAccent),
                                                  strokeWidth: 3,
                                                ),
                                              ))
                                            : RefreshIndicator(
                                                onRefresh: () async {
                                                  await fetchRestaurants(
                                                      isRefresh: true);
                                                },
                                                child: ListView.builder(
                                                    controller:
                                                        scrollController,
                                                    physics:
                                                        AlwaysScrollableScrollPhysics(),
                                                    itemCount:
                                                        restaurants!.length,
                                                    itemBuilder:
                                                        (context, count) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/restaurant_details",
                                                              arguments:
                                                                  restaurants![
                                                                      count]);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            RestaurantTile(
                                                              restaurant:
                                                                  restaurants![
                                                                      count],
                                                              userLocation:
                                                                  userLocation,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Divider(
                                                              color: Colors
                                                                      .blueGrey[
                                                                  800],
                                                            ),
                                                            fetchingNextPage ==
                                                                        true &&
                                                                    count ==
                                                                        (restaurants!.length -
                                                                            1)
                                                                ? Container(
                                                                    height: 40,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                      );
                                                    }),
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
