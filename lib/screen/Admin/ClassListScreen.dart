import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddClassScreen extends StatefulWidget {
  @override
  _AddClassScreenState createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  String? _selectedClass;
  String? _selectedSection;

  // List of class options
  final List<String> classOptions = ['1', '2', '3', '4', '5', '6', '7', '8'];

  // List of section options
  final List<String> sectionOptions = ['A', 'B', 'C'];

  // Function to add class and section to Firestore with incremented ID
  Future<void> _addClassToFirestore() async {
    if (_selectedClass == null || _selectedSection == null) {
      _showErrorDialog('Please select both class and section.');
      return;
    }

    try {
      // Fetch the latest document in the Class collection by ID
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Class')
          .orderBy('ID', descending: true)
          .limit(1)
          .get();

      int nextID;
      if (querySnapshot.docs.isEmpty) {
        // If no documents, start ID from 1
        nextID = 1;
      } else {
        var latestID = querySnapshot.docs.first['ID'];
        if (latestID is int) {
          nextID = latestID + 1;
        } else if (latestID is String) {
          nextID = int.tryParse(latestID) ?? 1;
        } else {
          throw Exception('Unexpected ID type in Firestore.');
        }
      }

      // Combine class and section
      String classField = _selectedClass! + _selectedSection!;

      // Add the class with incremented ID
      await FirebaseFirestore.instance.collection('Class').add({
        'Class': classField,
        'ID': nextID,
      });

      Navigator.of(context).pop(); // Close the screen after adding
    } catch (error) {
      _showErrorDialog('Failed to add class. Error: $error');
    }
  }

  // Function to delete a class document
  Future<void> _deleteClass(String docId) async {
  try {
    print('Attempting to delete document with ID: $docId'); // Debug message
    await FirebaseFirestore.instance.collection('Class').doc(docId).delete();
    print('Document deleted successfully'); // Debug message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Class deleted successfully')),
    );
  } catch (error) {
    print('Failed to delete class: $error'); // Debug message
    _showErrorDialog('Failed to delete class. Error: $error');
  }
}


  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('Add Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for class selection
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: InputDecoration(labelText: 'Select Class'),
              items: classOptions.map((String classNumber) {
                return DropdownMenuItem<String>(
                  value: classNumber,
                  child: Text(classNumber),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedClass = newValue;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Dropdown for section selection
            DropdownButtonFormField<String>(
              value: _selectedSection,
              decoration: InputDecoration(labelText: 'Select Section'),
              items: sectionOptions.map((String section) {
                return DropdownMenuItem<String>(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSection = newValue;
                });
              },
            ),
            SizedBox(height: 32.0),

            // Add Class button
            ElevatedButton(
              onPressed: _addClassToFirestore,
              child: Text('Add Class'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
              ),
            ),
            SizedBox(height: 32.0),

            // List of existing classes with delete option
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Class').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final classDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: classDocs.length,
                    itemBuilder: (context, index) {
                      var doc = classDocs[index];
                      return ListTile(
                        title: Text(doc['Class']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteClass(doc.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}