import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectScreen extends StatelessWidget {
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
        stream: FirebaseFirestore.instance.collection('Subject').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No subjects found.'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
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
                                      icon: Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        // Handle edit teacher
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        // Handle delete teacher
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
          // Handle adding a new subject
        },
        backgroundColor: Color(0xFF134B70),
        child: Icon(Icons.add, size: 32.0),
      ),
    );
  }
}
        