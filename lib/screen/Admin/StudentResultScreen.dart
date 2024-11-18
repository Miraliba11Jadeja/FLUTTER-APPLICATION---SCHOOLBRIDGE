import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentResultScreen extends StatelessWidget {
  final String studentId;
  final String studentName;

  StudentResultScreen({required this.studentId, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$studentName - Result'),
        backgroundColor: Color(0xFF134B70),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Marks')
            .where('name', isEqualTo: studentName)
            .get(), // Fetch marks based on studentId
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final marksDocs = snapshot.data!.docs;
          int totalMarks = 0;
          int scoredMarks = 0;
          Map<String, int> sectionDistribution = {};

          // Calculate total and scored marks for each section
          for (var doc in marksDocs) {
            final markData = doc.data() as Map<String, dynamic>;
            final subject = markData['subject'];
            final totalMarksInExam = markData['totalMarks'] as int; // Total marks for this exam
            final sections = markData['marks'] as Map<String, dynamic>; // Sections (A, B, etc.)

            totalMarks += totalMarksInExam;

            // Sum the section marks
            sections.forEach((section, marks) {
              sectionDistribution[section] = marks as int;
              scoredMarks += marks as int;
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Marks: $scoredMarks / $totalMarks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Section Distribution:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ...sectionDistribution.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      '${entry.key}: ${entry.value} marks',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                Text(
                  'Result: ${scoredMarks / totalMarks >= 0.4 ? 'Pass' : 'Fail'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: scoredMarks / totalMarks >= 0.4
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
