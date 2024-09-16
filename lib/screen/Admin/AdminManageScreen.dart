import 'package:flutter/material.dart';

class AdminManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Replace back icon with custom image
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png', // Make sure the path is correct
              fit: BoxFit.contain,
            ),
          ),
        ),

        title: Text('Welcome, AdminName'),
        backgroundColor: Color(0xFF134B70),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              radius: 20, // smaller size for the app bar
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 30, color: Colors.white),
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
                    opacity: 0.8, // Set opacity to make the background color visible
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/web-design1.jpg', // Add your image here
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
                    onTap: () {},
                  ),
                  SizedBox(height: 10),
                  AdminButton(
                    icon: Icons.person,
                    text: "STUDENTS",
                    onTap: () {},
                  ),
                  SizedBox(height: 10),
                  AdminButton(
                    icon: Icons.home,
                    text: "GENERAL",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Logout Button
          
            AdminButton(
              icon: Icons.logout,
              text: "LOGOUT",
              onTap: () {},
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
  final IconData icon;
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
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: isLogout ? Colors.red : Color(0xFF134B70),
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
