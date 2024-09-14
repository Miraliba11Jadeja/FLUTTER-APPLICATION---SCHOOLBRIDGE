import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/LoginAs.dart';
import 'package:school_bridge_app/screen/Splash_screen.dart';


void main() => runApp(MyApp()); // Corrected to runApp

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginAs(),
    ); // Currently, it shows a placeholdergi
  }
}
