import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bridge_app/screen/Admin/AddClassScreen.dart';
import 'package:school_bridge_app/screen/Admin/AddTeacher.dart';
import 'package:school_bridge_app/screen/Admin/EditTeacher.dart';

class ClassListScreen extends StatefulWidget {
  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  // Function to delete a teacher after confirmation
  void _deleteTeacher(String docId) {
    FirebaseFirestore.instance.collection('class').doc(docId).delete();
  }

  // Function to show confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Class'),
          content: Text('Are you sure you want to delete this class?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteTeacher(docId); // Call delete function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('CLASS'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Go back when back icon is pressed
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png', // Ensure this image is added in your project under the assets folder
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context)
                      .openEndDrawer(); // Open end drawer when menu icon is pressed
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF134B70),
                  ),
                  child: Center(
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              buildDrawerItem(context, 'assets/students.png', 'Student'),
              buildDrawerItem(context, 'assets/timetable.png', 'Schedule'),
              buildDrawerItem(context, 'assets/calendar.png', 'Event'),
              buildDrawerItem(context, 'assets/leave.png', 'Leave'),
              buildDrawerItem(context, 'assets/exam-time.png', 'Result'),
              buildDrawerItem(context, 'assets/chat.png', 'Feedback'),
              buildDrawerItem(
                  context, 'assets/loudspeaker.png', 'Announcement'),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Class').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final teacherDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: teacherDocs.length,
            itemBuilder: (context, index) {
              final teacherData =
                  teacherDocs[index].data() as Map<String, dynamic>;
              final docId = teacherDocs[index].id; // Get document ID

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Card(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Class: ${teacherData['Class']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text("                                     "),
                             IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Show confirmation dialog before deleting
                                _showDeleteConfirmationDialog(context, docId);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    // Navigate to AddClassScreen when add button is pressed
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddClassScreen()),
    );
  },
  child: Icon(Icons.add),
  backgroundColor: Color(0xFF134B70),
),

    );
  }

  ListTile buildDrawerItem(BuildContext context, String asset, String title) {
    return ListTile(
      leading: Image.asset(asset, width: 30, height: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
