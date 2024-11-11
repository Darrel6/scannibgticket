// ignore_for_file: unnecessary_const

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:scanning_ticket/home.dart';
import 'package:scanning_ticket/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  late final token;

  _SplashScreenState() {
    new Timer(const Duration(milliseconds: 5000), () {
      setState(() {
        if (token == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
        }
        if (token != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        }
      });
    });

    new Timer(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }
  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    log("token==================: ${token}");
    return token;
  }

  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: _isVisible ? 1.0 : 0.5,
            duration: const Duration(seconds: 2),
            child: Center(
              child: Container(
                height: 250.0,
                width: 250.0,
                child: Center(
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
