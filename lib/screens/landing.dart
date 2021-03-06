import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurantfinder/constants.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: kPrimaryColor,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                "images/restaurant.svg",
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 70, right: 70, bottom: 30, top: 30),
                child: Text(
                  "Find restaurants near your",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 70, right: 70),
                child: Text(
                  "Find the bests place to eat, Date locations or where to dine out with friends",
                  style: TextStyle(color: Colors.blueGrey[400], fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 60,
                      child: Stack(
                        children: [
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/login");
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.7 /
                                      2,
                                  child: Center(
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/signup");
                              },
                              child: Container(
                                height: 60,
                                width:
                                    MediaQuery.of(context).size.width * 0.7 / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
