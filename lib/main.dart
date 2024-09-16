import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/LoginAs.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginAs(),
    ); 
  }
}