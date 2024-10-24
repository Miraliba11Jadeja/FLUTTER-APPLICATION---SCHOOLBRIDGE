import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Function to add class and section to Firestore
  Future<void> _addClassToFirestore() async {
    if (_selectedClass == null || _selectedSection == null) {
      // Show an error if class or section is not selected
      _showErrorDialog('Please select both class and section.');
      return;
    }

    // Create the combined class field like "3A"
    String classField = _selectedClass! + _selectedSection!;

    // Add the class and ID to Firestore
    await FirebaseFirestore.instance.collection('Class').add({
      'Class': classField,  // Store combined Class and Section like "3A"
      'ID': _selectedClass, // Store just the Class number in the ID field
    });

    Navigator.of(context).pop(); // Close the screen after adding
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
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}
