import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantfinder/constants.dart';
import 'package:restaurantfinder/providers/auth_provider.dart';
import 'package:restaurantfinder/utils/util.dart';
import 'package:restaurantfinder/widgets/custom_textfield.dart';
import 'package:restaurantfinder/widgets/progress_button.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: double.infinity,
          color: kPrimaryColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Create an account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Find restaurants near you",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 25,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextField(
                              controller: email,
                              validator: (val) {
                                if (validateEmail(val!) == false) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                              hintText: "email",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: password,
                              validator: (val) {
                                if (val!.length <= 7) {
                                  return "Password must be at least 7 characters long";
                                }
                                return null;
                              },
                              obscureText: true,
                              hintText: "password",
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account? ",
                            style: TextStyle(
                                color: Colors.blueGrey[400], fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, "/login");
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ProgressButton(
                          text: "Register",
                          height: 60,
                          width: double.infinity,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .signup(email.text.trim(), password.text);
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                              } on SocketException catch (_) {
                                showBasicMessageDialog(
                                    "Check internet connection", context);
                              } catch (err) {
                                showBasicMessageDialog(err.toString(), context);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
