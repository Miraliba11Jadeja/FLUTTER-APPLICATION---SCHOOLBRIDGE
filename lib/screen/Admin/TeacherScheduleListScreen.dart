import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bridge_app/screen/Admin/AddScheduleScreen.dart';
import 'package:school_bridge_app/screen/Admin/ScheduleDisplayScreen.dart';

class TeacherScheduleListScreen extends StatefulWidget {
  @override
  _TeacherScheduleListScreenState createState() => _TeacherScheduleListScreenState();
}

class _TeacherScheduleListScreenState extends State<TeacherScheduleListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('TEACHER'),
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Teacher').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final teacherDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: teacherDocs.length,
            itemBuilder: (context, index) {
              final teacherData = teacherDocs[index].data() as Map<String, dynamic>;
              final teacherName = teacherData['Name'] ?? 'Unnamed Teacher';

              return GestureDetector(
                onTap: () => _showSchedule(context, teacherName),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ClassCard(className: teacherName),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showSchedule(BuildContext context, String teacherName) async {
    final scheduleSnapshot = await FirebaseFirestore.instance
        .collection('Schedule')
        .where('teacherName', isEqualTo: teacherName)
        .get();

    if (scheduleSnapshot.docs.isEmpty) {
      // Schedule not found, prompt to add a new schedule
      final shouldAdd = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No Schedule Found"),
            content: Text("Would you like to add a schedule for $teacherName?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text("Add Schedule"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (shouldAdd == true) {
        // Navigate to add schedule screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddScheduleScreen(teacherName: teacherName),
          ),
        );
      }
    } else {
      // Display the schedule
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleDisplayScreen(scheduleDocs: scheduleSnapshot.docs),
        ),
      );
    }
  }
}

class ClassCard extends StatelessWidget {
  final String className;

  ClassCard({required this.className});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          " $className",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
