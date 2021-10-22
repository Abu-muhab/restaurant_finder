import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurantfinder/constants.dart';

class ProgressButton extends StatefulWidget {
  final double height;
  final double width;
  final AsyncCallback? onTap;

  ProgressButton({this.height = 0, this.width = 0, this.onTap});

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  bool isExecuting = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        if (isExecuting) return;
        setState(() {
          isExecuting = true;
        });
        if (widget.onTap != null) {
          try {
            await widget.onTap!();
          } catch (e) {
            setState(() {
              isExecuting = false;
            });
            throw (e);
          }
          setState(() {
            isExecuting = false;
          });
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Center(
          child: isExecuting
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  "Register",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
