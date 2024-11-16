import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bridge_app/screen/Admin/AddTeacher.dart';
import 'package:school_bridge_app/screen/Admin/EditTeacher.dart';

class TeacherListScreen extends StatefulWidget {
  @override
  _TeacherListScreenState createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  // Function to delete a teacher after confirmation
  void _deleteTeacher(String docId) {
    FirebaseFirestore.instance.collection('Teacher').doc(docId).delete();
  }

  // Function to show confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Teacher'),
          content: Text('Are you sure you want to delete this teacher?'),
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
        title: Text('TEACHERS'),
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
                  Scaffold.of(context).openEndDrawer(); // Open end drawer when menu icon is pressed
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
              buildDrawerItem(context, 'assets/teacher.png', 'Teachers'),
              buildDrawerItem(context, 'assets/add.png', 'Subject'),
              buildDrawerItem(context, 'assets/timetable.png', 'Schedule'),
              buildDrawerItem(context, 'assets/chat.png', 'Feedback'),
              buildDrawerItem(context, 'assets/calendar.png', 'Event'),
              buildDrawerItem(context, 'assets/loudspeaker.png', 'Announcement'),
              buildDrawerItem(context, 'assets/holidays.png', 'Holiday'),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Teacher').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final teacherDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: teacherDocs.length,
            itemBuilder: (context, index) {
              final teacherData = teacherDocs[index].data() as Map<String, dynamic>;
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
                        Text(
                          "NAME: ${teacherData['Name']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "SUBJECTS: ${teacherData['Subjects'].join(', ')}", // Joining the subjects array
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "CLASSES: ${teacherData['Class'].join(', ')}", // Joining the classes array
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navigate to EditTeacher screen with the teacher's data or ID
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTeacherProfileScreen(
                                  teacherId: docId, // Pass the document ID
                                  teacherData: teacherData, // Pass the teacher's current data
                                ),
                              ),
                            );
                          },
                        ),

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
          // Handle add teacher action
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTeacher()),
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
