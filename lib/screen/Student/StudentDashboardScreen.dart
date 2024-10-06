import 'package:flutter/material.dart';
//import 'student_profile_screen.dart'; // Import the StudentProfileScreen

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF134B70),
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // Profile Icon
            onPressed: () {
              // Navigate to StudentProfileScreen when profile icon is clicked
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const StudentProfileScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem('assets/attendance.png', 'Attendance'),
            _buildDrawerItem('assets/chat.png', 'FeedBack'),
            _buildDrawerItem('assets/Profile.png', 'Profile'),
            _buildDrawerItem('assets/exam.png', 'Exam'),
            _buildDrawerItem('assets/timetable.png', 'Time-table'),
            _buildDrawerItem('assets/leave-apply.png', 'Apply Leave'),
            _buildDrawerItem('assets/event.png', 'Events and Activity'),
            _buildDrawerItem('assets/notification.png', 'Notifications'),
            _buildDrawerItem('assets/gallery.png', 'Gallery'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildDashboardItem(
              context,
              'assets/Profile.png', // Profile asset
              'PROFILE',
            ),
            _buildDashboardItem(
              context,
              'assets/holidays.png', // Holidays asset
              'HOLIDAYS',
            ),
            _buildDashboardItem(
              context,
              'assets/attendance.png', // Marks asset
              'ATTENDENCE',
            ),
            _buildDashboardItem(
              context,
              'assets/timetable.png', // Schedule asset
              'SCHEDULE',
            ),
            _buildDashboardItem(
              context,
              'assets/chat.png', // Feedback asset
              'FEEDBACK',
            ),
            _buildDashboardItem(
              context,
              'assets/event.png', // Event asset
              'EVENT',
            ),
            _buildDashboardItem(
              context,
              'assets/loudspeaker.png', // Announcement asset
              'ANNOUNCEMENT',
            ),
            _buildDashboardItem(
              context,
              'assets/gallery.png', // Announcement asset
              'GALLERY',
            ),
            _buildDashboardItem(
              context,
              'assets/good-score.png', // Results asset
              'RESULT',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String imagePath, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 20),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'PROFILE') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const StudentProfileScreen(),
          //   ),
          // );
        }
        // Handle other icons if needed
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF134B70),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Image.asset(
              imagePath,
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Black font as requested
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}