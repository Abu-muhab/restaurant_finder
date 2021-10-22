import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantfinder/providers/auth_provider.dart';
import 'package:restaurantfinder/screens/landing.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  bool initialised = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.user == null) {
                return LandingScreen();
              }
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    child: Text("Logout"),
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
