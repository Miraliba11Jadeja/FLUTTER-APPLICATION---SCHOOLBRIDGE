import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/LoginAs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user') ?? "";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginAs(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/L.png'), // Ensure this path is correct
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
