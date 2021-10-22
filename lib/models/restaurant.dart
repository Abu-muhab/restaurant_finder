import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurantfinder/models/review.dart';

class Restaurant {
  String? name;
  bool? isOpen;
  String? photoReference;
  String? placeId;
  double? rating;
  String? vicinity;
  LatLng? location;
  int totalUserRating;

  Restaurant(
      {this.isOpen,
      this.name,
      this.photoReference,
      this.placeId,
      this.rating,
      this.vicinity,
      this.location,
      this.totalUserRating = 0});

  factory Restaurant.fromJson(Map json) {
    return Restaurant(
        location: LatLng(json['geometry']['location']['lat'],
            json['geometry']['location']['lng']),
        name: json['name'],
        isOpen: json['opening_hours'] == null
            ? null
            : json['opening_hours']['open_now'],
        photoReference: json['photos'] == null || json['photos'].length == 0
            ? null
            : json['photos'][0]['photo_reference'],
        placeId: json['place_id'],
        rating: json['rating'] == null
            ? 0
            : double.parse(json['rating'].toString()),
        vicinity: json['vicinity'],
        totalUserRating: json['user_ratings_total'] == null
            ? 0
            : json['user_ratings_total']);
  }
}

class RestaurantDetails {
  List<String> photoReferences;
  List<Review> reviews;

  RestaurantDetails({this.photoReferences = const [], this.reviews = const []});

  factory RestaurantDetails.fromJson(Map json) {
    List<String> refs = [];
    if (json['photos'] != null) {
      List photos = json['photos'];
      photos.forEach((element) {
        refs.add(element['photo_reference']);
      });
    }

    List<Review> reviews = [];
    if (json['reviews'] != null) {
      List photos = json['reviews'];
      photos.forEach((element) {
        reviews.add(Review.fromJson(element));
      });
    }

    return RestaurantDetails(photoReferences: refs, reviews: reviews);
  }
}
