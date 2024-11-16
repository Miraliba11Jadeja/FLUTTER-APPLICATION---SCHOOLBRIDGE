import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:school_bridge_app/screen/LoginAs.dart'; // Import your login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that widget binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp()); // Run your app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF134B70), // AppBar background color
          iconTheme: IconThemeData(
            color: Colors.white, // Color of the AppBar icons (back arrow, etc.)
            size: 23, // Size of the AppBar icons
          ),
          titleTextStyle: TextStyle(
            color: Colors.white, // Color of the AppBar title
            fontSize: 20, // Font size of the AppBar title
            fontWeight: FontWeight.bold, // Font weight of the AppBar title
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF134B70), // Background color
            foregroundColor: Colors.white, // Text color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            elevation: 5, // Button shadow
          ),
        ),
      ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: LoginAs(), // Your login screen
    );
  }
}
