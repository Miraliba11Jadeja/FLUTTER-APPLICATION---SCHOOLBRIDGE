import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bridge_app/screen/Admin/AddClassScreen.dart';
import 'package:school_bridge_app/screen/Admin/ClassScheduleScreen.dart';
import 'package:school_bridge_app/screen/Admin/StudentListScreen.dart';
import 'package:school_bridge_app/screen/Admin/StudentResultListScreen.dart';

class ResultClassListScreen extends StatefulWidget {
  @override
  _ResultClassListScreenState createState() => _ResultClassListScreenState();
}

class _ResultClassListScreenState extends State<ResultClassListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('CLASS'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF134B70),
              ),
              child: Text(
                'Options',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            buildDrawerItem(context, 'assets/icon.png', 'Item 1'),
            buildDrawerItem(context, 'assets/icon.png', 'Item 2'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Class').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final classDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: classDocs.length,
            itemBuilder: (context, index) {
              final classData = classDocs[index].data() as Map<String, dynamic>;
              final className = classData['Class'] ?? 'Unnamed Class';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentResultListScreen(
                        className: className,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ClassCard(className: className),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  ListTile buildDrawerItem(BuildContext context, String asset, String title) {
    return ListTile(
      leading: Image.asset(asset, width: 30, height: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class ClassCard extends StatelessWidget {
  final String className;

  ClassCard({required this.className});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Class: $className",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
