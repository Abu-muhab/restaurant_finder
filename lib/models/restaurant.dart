import 'package:google_maps_flutter/google_maps_flutter.dart';

class Restaurant {
  String? name;
  bool? isOpen;
  String? photoReference;
  String? placeId;
  double? rating;
  String? vicinity;
  LatLng? location;

  Restaurant(
      {this.isOpen,
      this.name,
      this.photoReference,
      this.placeId,
      this.rating,
      this.vicinity,
      this.location});

  factory Restaurant.fromJson(Map json) {
    return Restaurant(
        location: LatLng(json['geometry']['location']['lat'],
            json['geometry']['location']['lng']),
        name: json['name'],
        isOpen: json['opening_hours']['open_now'],
        photoReference: json['photos'].length == 0
            ? null
            : json['photos'][0]['photo_reference'],
        placeId: json['place_id'],
        rating: json['rating'],
        vicinity: json['vicinity']);
  }
}
