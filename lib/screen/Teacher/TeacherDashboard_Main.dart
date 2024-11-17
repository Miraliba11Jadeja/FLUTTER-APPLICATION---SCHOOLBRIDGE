import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Admin/AnnouncementListScreen.dart';
import 'package:school_bridge_app/screen/Admin/EditTeacher.dart';
import 'package:school_bridge_app/screen/Admin/EventScreen.dart';
import 'package:school_bridge_app/screen/Teacher/Attendance_Screen.dart';
import 'package:school_bridge_app/screen/Teacher/FeedBack.dart';
import 'package:school_bridge_app/screen/Teacher/HolidayTeacherScreen.dart';
import 'package:school_bridge_app/screen/Teacher/MarksTeacherScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_bridge_app/screen/Teacher/SchedduleDisplayScreenT.dart';

class TeacherDashboardScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('User not logged in'));
    }

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
              'assets/back.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Teacher')
              .where('Email', isEqualTo: user.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            if (snapshot.data!.docs.isEmpty) {
              return Text('No teacher data found');
            }

            var teacherData = snapshot.data!.docs.first;
            String teacherName = teacherData['Name'] ?? 'Teacher';

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
                  .collection('Teacher')
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
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Teacher')
              .where('Email', isEqualTo: user.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            var teacherData = snapshot.data!.docs.first;
            String teacherName = teacherData['Name'] ?? 'Teacher';

            return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              children: [
                _buildDashboardItem(
                  imagePath: 'assets/attendance.png',
                  label: "ATTENDANCE",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardItem(
                  imagePath: 'assets/holidays.png',
                  label: "HOLIDAYS",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HolidayTeacherScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardItem(
                  imagePath: 'assets/score.png',
                  label: "MARKS",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarksScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardItem(
                  imagePath: 'assets/timetable.png',
                  label: "SCHEDULE",
                  onTap: () async {
                    final scheduleDocs = await FirebaseFirestore.instance
                        .collection('Schedule')
                        .where('teacherName', isEqualTo: teacherName)
                        .get();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleDisplayScreen(
                          teacherName: teacherName, // Pass teacherName
                          scheduleDocs: scheduleDocs.docs, // Pass scheduleDocs
                        ),
                      ),
                    );
                  },
                ),
                _buildDashboardItem(
                  imagePath: 'assets/chat.png',
                  label: "FEEDBACK",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackScreen(), // Replace ChatScreen with the actual chat screen
                      ),
                       );
                  },
                ),
                _buildDashboardItem(
                  imagePath: 'assets/calendar.png',
                  label: "EVENT",
                  onTap: () {
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => EventScreen(),
                     ),
                    );
                  },
                ),
                _buildDashboardItem(
                  imagePath: 'assets/loudspeaker.png',
                  label: "ANNOUNCEMENT",
                  onTap: () {
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => AnnouncementListScreen()),);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardItem({
    required String imagePath,
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
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
