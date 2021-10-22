import 'package:flutter/material.dart';

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
