import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantfinder/constants.dart';
import 'package:restaurantfinder/providers/auth_provider.dart';
import 'package:restaurantfinder/screens/index.dart';
import 'package:restaurantfinder/screens/landing.dart';
import 'package:restaurantfinder/screens/login.dart';
import 'package:restaurantfinder/screens/nearby.dart';
import 'package:restaurantfinder/screens/signup.dart';

void main() async {
  // Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nearby Restaurants',
        theme: Theme.of(context).copyWith(primaryColor: kPrimaryColor),
        routes: {
          "/nearby": (context)=> NearbyScreen(),
          "/landing": (context) => LandingScreen(),
          "/login": (context) => LoginScreen(),
          "/signup": (context) => SignupScreen(),
          "/": (context) => IndexScreen()
        },
        initialRoute: "/nearby");
  }
}
