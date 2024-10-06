import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Teacher/MarksTeacherScreen.dart';

void main() {
  runApp(MarksApp());
}

class MarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MarksScreen(),
    );
  }
}

class ManageMarksScreen extends StatefulWidget {
  @override
  _ManageMarksScreenState createState() => _ManageMarksScreenState();
}

class _ManageMarksScreenState extends State<ManageMarksScreen> {
  int? _selectedDistributions; // Number of distributions
  List<TextEditingController> _distributionNameControllers = [];
  List<TextEditingController> _totalMarksControllers = [];

  // Function to dynamically add text fields based on number of distributions
  void _generateFields(int numberOfDistributions) {
    _distributionNameControllers = List.generate(numberOfDistributions, (index) => TextEditingController());
    _totalMarksControllers = List.generate(numberOfDistributions, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    for (var controller in _distributionNameControllers) {
      controller.dispose();
    }
    for (var controller in _totalMarksControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Build the dynamic fields for inputting distribution names and total marks
  Widget _buildDynamicFields() {
    List<Widget> fields = [];
    for (int i = 0; i < _selectedDistributions!; i++) {
      fields.add(
        Column(
          children: [
            TextFormField(
              controller: _distributionNameControllers[i],
              decoration: InputDecoration(
                labelText: 'Name of Distribution ${i + 1}',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _totalMarksControllers[i],
              decoration: InputDecoration(
                labelText: 'Total Marks of ${i + 1}',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }
    return Column(children: fields);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('MANAGE MARKS'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to select the number of distributions
            DropdownButtonFormField<int>(
              value: _selectedDistributions,
              decoration: InputDecoration(
                labelText: 'No of Distribution',
                border: OutlineInputBorder(),
              ),
              items: List.generate(10, (index) => index + 1)
                  .map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedDistributions = newValue;
                  if (_selectedDistributions != null) {
                    _generateFields(_selectedDistributions!);
                  }
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedDistributions != null) {
                  setState(() {
                    _generateFields(_selectedDistributions!);
                  });
                }
              },
              child: Text('ENTER'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 90),
              ),
            ),
            SizedBox(height: 20),

            // Show the dynamic fields if the number of distributions is selected
            _selectedDistributions != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: _buildDynamicFields(),
                    ),
                  )
                : Container(),

            // Save Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedDistributions != null) {
                  // Handle the save logic
                  for (int i = 0; i < _selectedDistributions!; i++) {
                    print("Distribution ${i + 1} Name: ${_distributionNameControllers[i].text}");
                    print("Distribution ${i + 1} Marks: ${_totalMarksControllers[i].text}");
                  }

                  // Show a snackbar indicating the data is saved
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data saved successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Redirect to the MarksScreen after a short delay
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MarksScreen()),
                    );
                  });
                }
              },
              child: Text('SAVE'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 90),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
