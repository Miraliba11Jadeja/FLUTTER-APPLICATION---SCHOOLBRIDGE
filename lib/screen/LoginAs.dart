import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Student/StudentLoginPage.dart';
import 'package:school_bridge_app/screen/Teacher/TeacherLoginPage.dart';
import 'Admin/LoginScreen.dart';


class LoginAs extends StatefulWidget {
  const LoginAs({super.key});

  @override
  State<LoginAs> createState() => _DashboardState();
}

class _DashboardState extends State<LoginAs> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Container with Inverted Triangle and Circle Avatar
            Stack(
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: InvertedTriangleClipper(),
                  child: Container(
                    height: 208,
                    color: Color(0xFF134B70), // Corrected color syntax
                  ),
                ),
                Positioned(
                  top: 100, // Position the circle inside the triangle
                  child: Container(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/L.png'), // Adjust image path
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            // Separate Container for "WHO ARE YOU?" Text
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Color(0xFF134B70), // Same blue color as the top container
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'WHO ARE YOU?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
      
            SizedBox(height: 60),
      
            // Options: Student, Teacher, Admin
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoleCard(
                        imagePath: 'assets/Student1.png', // Adjust image path
                        label: 'STUDENT',
                        onTap: () {
                          // Handle student role selection
                          Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentLoginPage()),
                          );
                        },
                      ),
                      RoleCard(
                        imagePath: 'assets/Teacher1.png', // Adjust image path
                        label: 'TEACHER',
                        onTap: () {
                          // Handle teacher role selection
                          Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeacherLoginPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  RoleCard(
                    imagePath: 'assets/ADMIN1.png', // Adjust image path
                    label: 'ADMIN',
                    onTap: () {
                      // Handle admin role selection
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for the inverted triangle shape
class InvertedTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RoleCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  RoleCard({required this.imagePath, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Apply border radius to the image
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
