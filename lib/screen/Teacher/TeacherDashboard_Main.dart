import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Admin/EditTeacher.dart';
import 'package:school_bridge_app/screen/Teacher/Attendance_Screen.dart';
import 'package:school_bridge_app/screen/Teacher/HolidayTeacherScreen.dart';
import 'package:school_bridge_app/screen/Teacher/MarksTeacherScreen.dart';

class TeacherDashboardScreenMain extends StatelessWidget {
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
              'assets/back.png', // Ensure the correct path to your back icon image
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 3, // Display 3 items per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: [
            _buildDashboardItem(
              imagePath: 'assets/SUB.png', // Path to your "Teacher" image
              label: "PROFILE",
              onTap: () {
                // Navigate to Teacher List Section
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTeacher(),
                  ),
                );
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/attendance.png', // Path to your "Holidays" image
              label: "ATTENDANCE",
              onTap: () {
                // Navigate to Holidays Section
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceScreen(),
                  ),
                );
              },
            ),
            
            _buildDashboardItem(
              imagePath: 'assets/holidays.png', // Path to your "Holidays" image
              label: "HOLIDAYS",
              onTap: () {
                // Navigate to Holidays Section
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HolidayTeacherScreen(),
                  ),
                );
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/score.png', // Path to your "Subject" image
              label: "MARKS",
              onTap: () {
                // Navigate to Subject Section
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarksScreen(),
                  ),
                );
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/timetable.png', // Path to your "Schedule" image
              label: "SCHEDULE",
              onTap: () {
                // Navigate to Schedule Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/chat.png', // Path to your "Feedback" image
              label: "FEEDBACK",
              onTap: () {
                // Navigate to Feedback Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/calendar.png', // Path to your "Event" image
              label: "EVENT",
              onTap: () {
                // Navigate to Event Section
              },
            ),
            _buildDashboardItem(
              imagePath: 'assets/loudspeaker.png', // Path to your "Announcement" image
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

  // Helper method to build each dashboard item
  Widget _buildDashboardItem({
    required String imagePath, // Use image path for the image in the dashboard
    required String label, // Label below the icon
    required VoidCallback onTap, // Callback for click action
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF134B70), // Icon container background color
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Image.asset(
              imagePath, // Image asset reference
              width: 45, // Image width
              height: 45, // Image height
              fit: BoxFit.contain, // Ensure image scales correctly
            ),
          ),
          SizedBox(height: 10), // Space between image and label
          Text(
            label,
            style: TextStyle(
              fontSize: 12, // Font size of label
              fontWeight: FontWeight.bold, // Bold label text
            ),
          ),
        ],
      ),
    );
  }
}


// New TeacherDetailScreen to display the details of a tapped teacher
class TeacherDetailScreen extends StatelessWidget {
  final Map<String, String> teacher;

  TeacherDetailScreen({required this.teacher});

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
              'assets/back.png', // Ensure the correct path to your back icon image
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(teacher['name'] ?? 'Teacher Detail'),
        backgroundColor: Color(0xFF134B70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NAME: ${teacher['name']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "SUBJECT: ${teacher['subject']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              "CLASSES: ${teacher['classes']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back to List"),
            ),
          ],
        ),
      ),
    );
  }
}
