import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Admin/AnnouncementListScreen.dart';
import 'package:school_bridge_app/screen/Admin/ClassListScreen.dart';
import 'package:school_bridge_app/screen/Admin/EventScreen.dart';
import 'package:school_bridge_app/screen/Admin/ScheduleClassListScreen.dart';
import 'package:school_bridge_app/screen/Teacher/FeedBack.dart';

class StudentDashboardScreen extends StatelessWidget {
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
          crossAxisSpacing: 9,
          mainAxisSpacing: 20,
          children: [
            _buildDashboardItem(
              imagePath: 'assets/students.png', // Path to your image
              label: "STUDENTS",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClassListScreen()),
                );
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/timetable.png', // Path to your image
              label: "SCHEDULE",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleClassListScreen()),
                );
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/calendar.png', // Path to your image
              label: "EVENTS",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventScreen()),
                );
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/leave.png', // Path to your image
              label: "LEAVE",
              onTap: () {
                // Navigate to Schedule Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/exam-time.png', // Path to your image
              label: "RESULT",
              onTap: () {
                // Navigate to Feedback Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/chat.png', // Path to your image
              label: "FEEDBACK",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
                );
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/loudspeaker.png', // Path to your image
              label: "ANNOUNCEMENT",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnnouncementListScreen()),
                );
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
              width: 45, // Set the size of the image
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
