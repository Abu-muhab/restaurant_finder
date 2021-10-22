import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurantfinder/api/place_api.dart';
import 'package:restaurantfinder/constants.dart';
import 'package:restaurantfinder/models/restaurant.dart';
import 'package:restaurantfinder/widgets/progress_button.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  GoogleMapController? mapController;
  late LatLng initialCameraPosition;
  late Restaurant restaurant;

  bool fetchingDetails = false;
  RestaurantDetails? details;

  Future<void> fetchRestaurantDetails() async {
    try {
      if (fetchingDetails == true) {
        return;
      }
      setState(() {
        fetchingDetails = true;
      });
      RestaurantDetails details =
          await PlaceApi.getRestaurantDetails(restaurant.placeId!);
      setState(() {
        this.details = details;
        fetchingDetails = false;
      });
    } catch (err) {
      print(err.toString());
      setState(() {
        fetchingDetails = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context)?.settings.arguments as Restaurant;
    initialCameraPosition = restaurant.location!;

    Future.delayed(Duration(seconds: 1), () {
      fetchRestaurantDetails();
    });

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: initialCameraPosition, zoom: 15),
                      onMapCreated: (controller) {
                        mapController = controller;
                        rootBundle.loadString("assets/grey.json").then((style) {
                          controller.setMapStyle(style);
                        });
                      },
                      markers: [
                        Marker(
                            markerId: MarkerId("rrr"),
                            position: initialCameraPosition,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure)),
                      ].toSet(),
                    ),
                    SafeArea(
                        child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: Color.fromARGB(200, 196, 196, 196)),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xffF7F7F8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
                  // height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          topLeft: Radius.circular(24))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        restaurant.name!,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: restaurant!.totalUserRating.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                          children: [
                            TextSpan(
                                text: " total ratings | ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                            TextSpan(
                                text: "10",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                            TextSpan(
                                text: "km |  ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                            TextSpan(
                                text: "${restaurant!.rating.toString()}  ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      details == null && fetchingDetails == false
                          ? Expanded(
                              child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "images/error.svg",
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        bottom: 20,
                                        top: 20),
                                    child: Text(
                                      "Error fetching restaurant details. Try again",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ProgressButton(
                                    height: 50,
                                    width: 200,
                                    text: "Reload",
                                    onTap: () async {
                                      await fetchRestaurantDetails();
                                    },
                                  )
                                ],
                              ),
                            ))
                          : details == null && fetchingDetails == true
                              ? Expanded(
                                  child: Center(
                                      child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blueAccent),
                                    strokeWidth: 3,
                                  ),
                                )))
                              : Expanded(
                                  child: Column(
                                  children: [
                                    SizedBox(
                                      height: 140,
                                      child: details!.photoReferences.length ==
                                              0
                                          ? Center(
                                              child: Text(
                                                "No photos",
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                            )
                                          : ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, count) {
                                                return Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 140,
                                                      width: 140,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: PlaceApi
                                                              .getImageUrlFromReference(
                                                                  details!.photoReferences[
                                                                      count]),
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (context, url) {
                                                            return Container(
                                                              color:
                                                                  kPrimaryColorLight,
                                                              height: 140,
                                                              width: 140,
                                                              child: Center(
                                                                child: SizedBox(
                                                                  height: 25,
                                                                  width: 25,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .blueAccent),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          errorWidget: (context,
                                                              string, _) {
                                                            return Container(
                                                              color:
                                                                  kPrimaryColorLight,
                                                              height: 140,
                                                              width: 140,
                                                              child: Icon(
                                                                Icons
                                                                    .broken_image_outlined,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                );
                                              },
                                              itemCount: details!
                                                  .photoReferences.length,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 300,
                                        child: Text("Reviews",
                                            style: TextStyle(
                                                color: Color(0xffB0B0B0),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    ProgressButton(
                                      height: 56,
                                      text: "Make reservation",
                                      onTap: () async {},
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
