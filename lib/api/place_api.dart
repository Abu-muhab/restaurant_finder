import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:restaurantfinder/models/restaurant.dart';

class PlaceApi {
  static String baseUrl = "https://maps.googleapis.com/maps/api/place";
  static String apiKey = "AIzaSyB_rPr66VTngzCveTyuIed5C_Rs3CAApfE";

  static Future<RestaurantDetails> getRestaurantDetails(String placeId) async {
    try {
      http.Response response = await http.get(Uri.parse(baseUrl +
          "/details/json?place_id=$placeId&key=$apiKey&fields=photos,reviews"));

      print(response.body);

      if (response.statusCode == 200) {
        Map result = JsonDecoder().convert(response.body)['result'];
        return RestaurantDetails.fromJson(result);
      } else {
        throw "Error fetching details";
      }
    } on SocketException catch (_) {
      throw "No internet connection";
    }
  }

  static Future<NearbyRestaurantResponse> getNearbyRestaurants(
      LatLng userLocation,
      {String? pageToken}) async {
    try {
      http.Response response = await http.get(Uri.parse(baseUrl +
          "/nearbysearch/json?location=${userLocation.latitude},${userLocation.longitude}&radius=10000&type=restaurant&keyword=food&key=$apiKey&${pageToken == null ? "" : "pagetoken=$pageToken"}"));

      if (response.statusCode == 200) {
        List results = JsonDecoder().convert(response.body)['results'];
        List<Restaurant> restaurants = [];
        results.forEach((restaurantJson) {
          restaurants.add(Restaurant.fromJson(restaurantJson));
        });

        NearbyRestaurantResponse nr = NearbyRestaurantResponse(
            restaurants: restaurants,
            nextPageToken:
                JsonDecoder().convert(response.body)['next_page_token']);
        return nr;
      } else {
        throw "Error fetching restaurants";
      }
    } on SocketException catch (_) {
      throw "No internet connection";
    }
  }

  static String getImageUrlFromReference(String reference) {
    return baseUrl +
        "/photo?photo_reference=$reference&key=$apiKey&maxwidth=400";
  }
}

class NearbyRestaurantResponse {
  List<Restaurant> restaurants;
  String? nextPageToken;

  NearbyRestaurantResponse({this.restaurants = const [], this.nextPageToken});
}
