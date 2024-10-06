import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Teacher/EditMarksTeacherScreen.dart';
import 'package:school_bridge_app/screen/Teacher/ManageMarksScreen.dart';

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

class MarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('MARKS'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildOptionButton(context, 'MANAGE MARKS', () => _onManageMarks(context)),
            SizedBox(height: 16),
            _buildOptionButton(context, 'EDIT MARKS', () => _onEditMarks(context)),
            SizedBox(height: 16),
            _buildOptionButton(context, 'ADD MARKS', () => _onAddMarks(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: const Color.fromARGB(255, 19, 134, 227), width: 2),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _onManageMarks(BuildContext context) {
    // Handle the manage marks button press
    Navigator.push(context, MaterialPageRoute(builder: (context) => ManageMarksScreen()));
  }

  void _onEditMarks(BuildContext context) {
    // Handle the edit marks button press
    // Navigate or do something here
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditMarksScreen()));
  }

  void _onAddMarks(BuildContext context) {
    // Handle the add marks button press
    // Navigate or do something here
  }
}
