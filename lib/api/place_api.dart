import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:restaurantfinder/models/restaurant.dart';

class PlaceApi {
  static String baseUrl = "https://maps.googleapis.com/maps/api/place";
  static Future<List<Restaurant>> getNearbyRestaurants(
      LatLng userLocation) async {
    try {
      http.Response response = await http.get(Uri.parse(baseUrl +
          "/nearbysearch/json?location=${userLocation.latitude},${userLocation.longitude}&radius=10000&type=restaurant&key=food"));

      if (response.statusCode == 200) {
        List results = JsonDecoder().convert(response.body)['results'];
        List<Restaurant> restaurants = [];
        results.forEach((restaurantJson) {
          restaurants.add(Restaurant.fromJson(restaurantJson));
        });
        return restaurants;
      } else {
        throw "Error fetching restaurants";
      }
    } on SocketException catch (err) {
      throw "No internet connection";
    }
  }
}
