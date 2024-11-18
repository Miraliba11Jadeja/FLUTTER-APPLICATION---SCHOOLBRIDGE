import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Teacher/AddMarksScreen.dart';
import 'package:school_bridge_app/screen/Teacher/EditMarksListScreen.dart';
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
  // Declare a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
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
              // Use the GlobalKey to open the end drawer
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF134B70),
                  ),
                  child: Center(
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              buildDrawerItem(context, 'assets/SUB.png', 'Profile'),
              buildDrawerItem(context, 'assets/attendance.png', 'Attendance'),
              buildDrawerItem(context, 'assets/timetable.png', 'Schedule'),
              buildDrawerItem(context, 'assets/chat.png', 'Feedback'),
              buildDrawerItem(context, 'assets/calendar.png', 'Event'),
              buildDrawerItem(
                  context, 'assets/loudspeaker.png', 'Announcement'),
              buildDrawerItem(context, 'assets/holidays.png', 'Holiday'),
              buildDrawerItem(context, 'assets/score.png', 'Marks'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildOptionButton(
                context, 'MANAGE MARKS', () => _onManageMarks(context)),
            SizedBox(height: 16),
            _buildOptionButton(
                context, 'EDIT MARKS', () => _onEditMarks(context)),
            SizedBox(height: 16),
            _buildOptionButton(
                context, 'ADD MARKS', () => _onAddMarks(context)),
          ],
        ),
      ),
    );
  }

  ListTile buildDrawerItem(BuildContext context, String asset, String title) {
    return ListTile(
      leading: Image.asset(asset, width: 30, height: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.of(context).pop(); // Close the drawer when item is tapped
      },
    );
  }

  Widget _buildOptionButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: const Color.fromARGB(255, 19, 134, 227), width: 2),
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
    // Navigate to Manage Marks screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ManageMarksScreen()));
  }

  void _onEditMarks(BuildContext context) {
    // Navigate to Edit Marks screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditMarksList()));
  }

  void _onAddMarks(BuildContext context) {
    // Handle the add marks button press (navigate or do something)
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddMarksScreen ()));
  }
}
