import 'package:flutter/material.dart';

void main() {
  runApp(MarksApp());
}

class MarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditMarksScreen(),
    );
  }
}

class EditMarksScreen extends StatefulWidget {
  @override
  _EditMarksScreenState createState() => _EditMarksScreenState();
}

class _EditMarksScreenState extends State<EditMarksScreen> {
  List<Map<String, dynamic>> distributions = [
    {"name": "Reading", "marks": "20"},
    {"name": "Writing", "marks": "20"},
    {"name": "Speaking", "marks": "20"}
  ];

  // Controllers for each distribution
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> marksControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  // Initialize controllers for each distribution field
  void _initializeControllers() {
    nameControllers = distributions
        .map((dist) => TextEditingController(text: dist['name']))
        .toList();
    marksControllers = distributions
        .map((dist) => TextEditingController(text: dist['marks']))
        .toList();
  }

  // Function to add a new distribution
  void _addDistribution() {
    setState(() {
      distributions.add({"name": "", "marks": ""});
      nameControllers.add(TextEditingController());
      marksControllers.add(TextEditingController());
    });
  }

  // Function to update the list of distributions (editing or saving)
  void _saveDistributions() {
    setState(() {
      for (int i = 0; i < distributions.length; i++) {
        distributions[i]["name"] = nameControllers[i].text;
        distributions[i]["marks"] = marksControllers[i].text;
      }
    });
  }

  // Build distribution fields
  Widget _buildDistributionFields() {
    return Column(
      children: distributions.asMap().entries.map((entry) {
        int index = entry.key;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name of Distribution ${index + 1}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameControllers[index],
              decoration: InputDecoration(
                hintText: "Enter name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Total Marks of ${index + 1}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: marksControllers[index],
              decoration: InputDecoration(
                hintText: "Enter marks",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('EDIT MARKS'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
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
        padding: const EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDistributionFields(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addDistribution,
                    child: Text('ADD DISTRIBUTION'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF134B70),
                      padding:
                          EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveDistributions,
                    child: Text('SAVE DISTRIBUTIONS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF134B70),
                      padding:
                          EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
