import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Admin/EditTeacher.dart';
import 'package:school_bridge_app/screen/Admin/HolidayAdminScreen.dart';
import 'package:school_bridge_app/screen/Student/HolidayScreen.dart';
import 'package:school_bridge_app/screen/Student/ScheduleScreen.dart';
import 'student_profile_screen.dart'; // Import the StudentProfileScreen

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('User not logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF134B70),
        title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Student')
              .where('Email', isEqualTo: user.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            if (snapshot.data!.docs.isEmpty) {
              return Text('No student data found');
            }

            var teacherData = snapshot.data!.docs.first;
            String teacherName = teacherData['Name'] ?? 'Student';

            return Text(
              'Hi, $teacherName',
              style: TextStyle(color: Colors.white),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Student')
                  .where('Email', isEqualTo: user.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: CircularProgressIndicator(),
                  );
                }

                var teacherData = snapshot.data!.docs.first;
                String profileImageUrl = teacherData['ProfilePicture'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditTeacherProfileScreen(
                          teacherId: teacherData.id, // Pass the document ID
                          teacherData: teacherData.data()
                              as Map<String, dynamic>, // Use .data() to convert
                        ),
                      ),
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
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
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
              'assets/calendar.png', // Event asset
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
              'assets/exam-time.png', // Results asset
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
        if (label == 'HOLIDAYS') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  HolidayScreen(),
            ),
          );
        }

        if (label == 'SCHEDULE') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  ScheduleScreen(
                className: '1A',
              ),
            ),
          );
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
