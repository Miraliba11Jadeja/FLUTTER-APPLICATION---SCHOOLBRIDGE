import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Admin/AdminManageScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_bridge_app/screen/Admin/ForgotScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(SchoolBridgeApp());
}

class SchoolBridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> _login() async {
  String Username = _usernameController.text.trim();
  String Password = _passwordController.text.trim();

  // Input validation
  if (Username.isEmpty || Password.isEmpty) {
    _showErrorDialog('Please enter both email and password.');
    return;
  }

  try {
    // Sign in the user using Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: Username,
      password: Password,
    );

    // If sign in is successful, check Firestore for admin email
    var adminCollection = _firestore.collection('Admin');
    var adminQuery = await adminCollection.where('Email', isEqualTo: Username).get();

    if (adminQuery.docs.isNotEmpty) {
      // Proceed to AdminManageScreen if the user is in the Admin collection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminManageScreen()),
      );
    } else {
      // Log out the user if not found in Admin collection
      await FirebaseAuth.instance.signOut();
      _showErrorDialog('You are not authorized to access this application.');
    }
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase auth errors
    if (e.code == 'user-not-found') {
      _showErrorDialog('No user found with this email.');
    } else if (e.code == 'wrong-password') {
      _showErrorDialog('Incorrect password. Please try again.');
    } else {
      _showErrorDialog('An error occurred: ${e.message}');
    }
  } catch (e) {
    // Catch any other errors during the process
    _showErrorDialog('An error occurred: $e');
  }
}

  // Error dialog function
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

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
            SizedBox(height: 80),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username Field
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your Email',
                          prefixIcon: Icon(Icons.person),
                          border: InputBorder.none,
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

                    // Password Field
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
                                _obscureText = !_obscureText; // Toggle password visibility
                              });
                            },
                          ),
                          border: InputBorder.none,
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
                        onPressed: _login,
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

// Custom triangle clipper for the logo
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