import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurantfinder/api/place_api.dart';
import 'package:restaurantfinder/constants.dart';
import 'package:restaurantfinder/models/restaurant.dart';
import 'package:restaurantfinder/widgets/star_rating.dart';

class RestaurantTile extends StatelessWidget {
  final Restaurant? restaurant;
  RestaurantTile({this.restaurant});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: PlaceApi.getImageUrlFromReference(
                    restaurant!.photoReference.toString()),
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    color: kPrimaryColorLight,
                    height: 120,
                    width: 140,
                    child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        ),
                      ),
                    ),
                  );
                },
                errorWidget: (context, string, _) {
                  return Container(
                    color: kPrimaryColorLight,
                    height: 120,
                    width: 140,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant!.name.toString(),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                restaurant!.vicinity.toString(),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                height: 4,
              ),
              StarRating(
                rating: restaurant!.rating!,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Icon(
                    Icons.directions_outlined,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "5 miles away",
                    style: TextStyle(color: Colors.blueGrey),
                  )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Chip(
                label: Text(
                  restaurant!.isOpen == null || restaurant!.isOpen == false
                      ? "Closed"
                      : "Open",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor:
                    restaurant!.isOpen == null || restaurant!.isOpen == false
                        ? Colors.redAccent
                        : Colors.green,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
