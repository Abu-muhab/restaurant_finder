import 'package:flutter/material.dart';
import 'package:restaurantfinder/constants.dart';
import 'package:restaurantfinder/screens/landing.dart';
import 'package:restaurantfinder/screens/login.dart';
import 'package:restaurantfinder/screens/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Theme.of(context).copyWith(primaryColor: kPrimaryColor),
        routes: {
          "/landing": (context) => LandingScreen(),
          "/login": (context) => LoginScreen(),
          "/signup": (context) => SignupScreen(),
        },
        initialRoute: "/landing");
  }
}
