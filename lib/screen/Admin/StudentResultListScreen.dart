import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'StudentResultScreen.dart'; // Import the correct result screen

class StudentResultListScreen extends StatefulWidget {
  final String className;

  StudentResultListScreen({required this.className});

  @override
  _StudentResultListScreenState createState() =>
      _StudentResultListScreenState();
}

class _StudentResultListScreenState extends State<StudentResultListScreen> {
  // Function to delete a student after confirmation
  void _deleteStudent(String docId) {
    FirebaseFirestore.instance.collection('Student').doc(docId).delete();
  }

  // Function to show confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Student'),
          content: Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteStudent(docId); // Call delete function
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
        title: Text('STUDENTS - ${widget.className}'), // Display the class name
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Student')
            .where('Class', isEqualTo: widget.className) // Filter by class name
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final studentDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: studentDocs.length,
            itemBuilder: (context, index) {
              final studentData =
                  studentDocs[index].data() as Map<String, dynamic>;
              final docId = studentDocs[index].id; // Get document ID

              return GestureDetector(
                onTap: () {
                  // Navigate to result screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentResultScreen(
                        studentId: docId,
                        studentName: studentData['Name'],
                      ),
                    ),
                  );
                },
                child: Padding(
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
                            "NAME: ${studentData['Name']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Roll No: ${studentData['RollNo']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
