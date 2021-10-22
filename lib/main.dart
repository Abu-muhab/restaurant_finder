import 'package:flutter/material.dart';
import 'package:restaurantfinder/screens/constants.dart';
import 'package:restaurantfinder/screens/landing.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Theme.of(context).copyWith(
        primaryColor: kPrimaryColor
      ),
     routes: {
        "/landing": (context)=> LandingScreen()
     },
     initialRoute: "/landing"
    );
  }
}
