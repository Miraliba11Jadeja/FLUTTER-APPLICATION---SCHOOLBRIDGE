import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bridge_app/screen/Teacher/EditMarksTeacherScreen.dart';


void main() {
  runApp(AddMarksApp());
}

class AddMarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditMarksList(),
    );
  }
}

class EditMarksList extends StatefulWidget {
  @override
  _EditMarksListState createState() => _EditMarksListState();
}

class _EditMarksListState extends State<EditMarksList> {
  String? selectedClass;
  String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF134B70), // Dark Blue color
        title: const Text('ADD MARKS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Dropdown for Class
            buildDropdownButton(
              'Select Class',
              [],
              selectedClass,
              (value) {
                setState(() {
                  selectedClass = value;
                });
              },
              'Class', // Firestore collection for classes
            ),
            const SizedBox(height: 16),

            // Dropdown for Subject
            buildDropdownButton(
              'Select Subject',
              [],
              selectedSubject,
              (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
              'Subject', // Firestore collection for subjects
            ),
            const SizedBox(height: 16),

            // Dropdown for Type
           
            const SizedBox(height: 40),

            // Proceed Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF134B70), // Dark Blue color for the button
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                // Validate that all dropdown values are selected
                if (selectedClass == null ||
                    selectedSubject == null
                    ) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Incomplete Selection"),
                        content: const Text(
                            "Please select all fields before proceeding."),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                // Check if the selected class and subject combination exists in the marksList
                bool exists =
                    await checkMarksList(selectedClass, selectedSubject);
                if (exists) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMarksScreen(
                        selectedClass: selectedClass!,
                        selectedSubject: selectedSubject!,
                      ),
                    ),
                  );
                } else {
                  // Show a message if combination doesn't exist
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Not Found"),
                        content: const Text(
                            "No marks record found for this combination. Please set the details first."),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Center(
                child: Text(
                  'PROCEED',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown Builder
  Widget buildDropdownButton(String hintText, List<String> items,
      String? selectedItem, ValueChanged<String?> onChanged,
      [String? collection]) {
    if (collection == null) {
      // Use provided items directly for Type and Exam dropdowns
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF134B70), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        value: selectedItem,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      );
    }

    // For Firestore-backed dropdowns
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          return const Text('No data available');
        }

        // Prepare dropdown list
        List<String> data = [];
        snapshot.data!.docs.forEach((doc) {
          // Adjust field name based on collection
          String fieldName = (collection == 'Class') ? 'Class' : 'Name';
          data.add(doc[fieldName]); // Fetch the correct field
        });

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF134B70), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
          value: selectedItem,
          onChanged: onChanged,
          items: data.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        );
      },
    );
  }

  // Function to check if the class and subject already exist in the marksList
  Future<bool> checkMarksList(
      String? selectedClass, String? selectedSubject) async {
    if (selectedClass == null || selectedSubject == null) {
      return false;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('markslist')
        .where('class', isEqualTo: selectedClass)
        .where('subject', isEqualTo: selectedSubject)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
