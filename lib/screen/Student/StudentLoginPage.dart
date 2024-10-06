import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Admin/AdminManageScreen.dart';
import 'dart:math';

import 'package:school_bridge_app/screen/Admin/ForgotScreen.dart';
import 'StudentDashboardScreen.dart';

void main() {
  runApp(SchoolBridgeApp());
}

class SchoolBridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentLoginPage(),
    );
  }
}

class StudentLoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<StudentLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Triangle with logo
            Stack(
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: InvertedTriangleClipper(),
                  child: Container(
                    height: 200,
                    color: Color(0xFF134B70),
                  ),
                ),
                Positioned(
                  top: 90,
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage('assets/L.png'), // Replace with your image asset
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height : 80),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username Field with Underline
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          prefixIcon: Icon(Icons.person),
                          border: InputBorder.none, // No border, only underline
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF134B70)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
      
                    // Password Field with Underline
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
      
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: InputBorder.none, // No border, only underline
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF134B70)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
      
                    // Login Button
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: Color(0xFF134B70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          // Perform login validation here
                          // For now, let's navigate to the dashboard screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StudentDashboardScreen()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
      
                    // Forgot Password Link
                    TextButton(
                      onPressed: () {
                            // Handle forgot password action here
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgetScreen()),
                            );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvertedTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class DashboardScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
