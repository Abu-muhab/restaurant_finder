import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;

void showBasicMessageDialog(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OKAY",
                  style: TextStyle(color: Colors.blueAccent),
                ))
          ],
        );
      });
}

Future<bool> showBasicConfirmationDialog(String message, BuildContext context,
    {String positiveLabel = "", String negativeLabel = ""}) async {
  bool value = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  positiveLabel != null ? positiveLabel : "YES",
                  style: TextStyle(color: Colors.blueAccent),
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  negativeLabel != null ? negativeLabel : "NO",
                  style: TextStyle(color: Colors.blueAccent),
                ))
          ],
        );
      });
  return value;
}

bool validateEmail(String val) {
  String value = val.trim();
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

void showPersistentLoadingIndicator(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          ),
        );
      },
      barrierDismissible: false);
}

double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

