import 'package:flutter/material.dart';

class GeneralDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
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
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: [
            _buildDashboardItem(
              imagePath: 'assets/add.png', // Path to your image
              label: "TEACHER",
              onTap: () {
                // Navigate to Teacher Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/holidays.png', // Path to your image
              label: "HOLIDAYS",
              onTap: () {
                // Navigate to Holidays Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/teacher.png', // Path to your image
              label: "SUBJECT",
              onTap: () {
                // Navigate to Subject Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/timetable.png', // Path to your image
              label: "SCHEDULE",
              onTap: () {
                // Navigate to Schedule Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/chat.png', // Path to your image
              label: "FEEDBACK",
              onTap: () {
                // Navigate to Feedback Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/calendar.png', // Path to your image
              label: "EVENT",
              onTap: () {
                // Navigate to Event Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/loudspeaker.png', // Path to your image
              label: "ANNOUNCEMENT",
              onTap: () {
                // Navigate to Announcement Section
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each dashboard item with images
  Widget _buildDashboardItem({
    required String imagePath, // Use image path instead of IconData
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF134B70),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              width: 45,  // Set the size of the image
              height: 45, // Set the size of the image
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
