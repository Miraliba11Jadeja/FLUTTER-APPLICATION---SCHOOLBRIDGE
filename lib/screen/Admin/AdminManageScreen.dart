import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bridge_app/screen/Admin/AdminProfileScreen.dart';
import 'package:school_bridge_app/screen/Admin/GeneralDashboardScreen.dart';
import 'package:school_bridge_app/screen/Admin/StudentDashboardScreen.dart';
import 'package:school_bridge_app/screen/Admin/TeacherDashboardSCreen.dart';
import 'package:school_bridge_app/screen/LoginAs.dart';

class AdminManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Admin').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            var adminData = snapshot.data!.docs.first; // Get the first document
            String adminName = adminData['Name'] ?? 'Admin'; // Fetch admin name
            return Text('Welcome, $adminName', 
                        style: TextStyle(color: Colors.white),);
          },
        ),
        backgroundColor: Color(0xFF134B70),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Admin').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: CircularProgressIndicator(),
                  );
                }

                var adminData = snapshot.data!.docs.first;
                String profileImageUrl = adminData['profileImageUrl'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AdminProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl.isEmpty
                        ? Icon(Icons.person, size: 30, color: Colors.white)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Section inside a Stack with background color
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF134B70),
              ),
              child: Stack(
                children: [
                  // Background color
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF134B70),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Image with semi-transparency
                  Opacity(
                    opacity: 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/web-design1.jpg',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Buttons Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AdminButton(
                    icon: Icons.school,
                    text: "TEACHERS",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TeacherDashboardScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  AdminButton(
                    icon: Icons.person,
                    text: "STUDENTS",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => StudentDashboardScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  AdminButton(
                    icon: Icons.home,
                    text: "GENERAL",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GeneralDashboardScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Logout Button
            AdminButton(
              icon: Icons.logout,
              text: "LOGOUT",
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginAs()),
                );
              },
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable AdminButton Widget
class AdminButton extends StatelessWidget {
  final dynamic icon; // Can accept IconData or String (for asset image)
  final String text;
  final VoidCallback onTap;
  final bool isLogout;

  const AdminButton({
    required this.icon,
    required this.text,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10), // Margin around the button
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLogout ? Color(0xFFCC3F4D) : Color(0xFF134B70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // Padding inside the button
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text and icon close together
              Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 21, color: Colors.white),
                  ),
                  SizedBox(width: 10), // Control spacing between text and icon
                ],
              ),

              // Icon or Image on the right side
              isLogout
                  ? Image.asset(
                      'assets/logout.png', // Replace with your logout image path
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    )
                  : Icon(icon, size: 30, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
