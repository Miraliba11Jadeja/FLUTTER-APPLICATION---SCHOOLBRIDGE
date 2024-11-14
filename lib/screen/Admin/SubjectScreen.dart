import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to delete the teacher from the subject
  Future<void> deleteTeacherFromSubject(String subjectId, String teacherName) async {
    try {
      // First, get the subject document
      DocumentSnapshot subjectDoc = await _firestore.collection('Subject').doc(subjectId).get();

      if (subjectDoc.exists) {
        List<dynamic> teachers = subjectDoc['TName'];

        // Remove the teacher from the subject's teachers list
        teachers.remove(teacherName);

        // Update the subject document with the new teachers list
        await _firestore.collection('Subject').doc(subjectId).update({'TName': teachers});

        // Now, check if the teacher has other subjects
        QuerySnapshot teacherSubjects = await _firestore.collection('Subject')
            .where('TName', arrayContains: teacherName)
            .get();

        if (teacherSubjects.docs.length == 1) {
          // If the teacher has only one subject, show a warning and don't remove the teacher
          return;
        }

        // Remove the teacher from the Teacher collection if they have other subjects
        QuerySnapshot teacherDoc = await _firestore.collection('Teacher')
            .where('Name', isEqualTo: teacherName)
            .get();

        if (teacherDoc.docs.isNotEmpty) {
          await _firestore.collection('Teacher').doc(teacherDoc.docs.first.id).update({
            'Subjects': FieldValue.arrayRemove([subjectId])
          });
        }
      }
    } catch (e) {
      print('Error deleting teacher: $e');
    }
  }

  // Function to add a new subject
  Future<void> addSubject(String subjectName) async {
    try {
      // Add the new subject to Firestore
      await _firestore.collection('Subject').add({
        'Name': subjectName,
        'TName': [], // Empty list of teachers initially
      });
    } catch (e) {
      print('Error adding subject: $e');
    }
  }

  // Function to show the dialog for adding a new subject
  void _showAddSubjectDialog(BuildContext context) {
    TextEditingController subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Subject'),
          content: TextField(
            controller: subjectController,
            decoration: InputDecoration(hintText: 'Enter subject name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String subjectName = subjectController.text.trim();

                if (subjectName.isNotEmpty) {
                  await addSubject(subjectName); // Add the new subject
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show error if the subject name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Subject name cannot be empty')),
                  );
                }
              },
              child: Text('Add'),
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
        title: Text('SUBJECT'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Subject').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Subjects Found.'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              String subjectId = doc.id; // Get the subject ID
              String subjectName = doc['Name']; // Subject name field
              List<dynamic> teachers = doc['TName']; // Array of teachers

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Name
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF134B70),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            subjectName.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Teachers List
                      SizedBox(height: 4),
                      ...teachers.map((teacher) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  teacher,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        // Check if the teacher can be deleted
                                        QuerySnapshot teacherSubjects = await _firestore.collection('Subject')
                                            .where('TName', arrayContains: teacher)
                                            .get();

                                        if (teacherSubjects.docs.length == 1) {
                                          // Show a warning if the teacher has only one subject
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Warning'),
                                                content: Text('This teacher has only one subject assigned and cannot be removed.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          // Proceed with deleting the teacher
                                          await deleteTeacherFromSubject(subjectId, teacher);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSubjectDialog(context); // Show the dialog to add a subject
        },
        backgroundColor: Color(0xFF134B70),
        child: Icon(Icons.add, size: 32.0),
      ),
    );
  }
}
