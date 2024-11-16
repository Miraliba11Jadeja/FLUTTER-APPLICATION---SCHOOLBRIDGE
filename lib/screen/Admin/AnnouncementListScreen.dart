import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Announcement model class
class Announcement {
  final String id;
  final String title;
  final String date;
  final String description;

  Announcement({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
  });

  // Convert a Firestore document to an Announcement
  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    return Announcement(
      id: doc.id,
      title: doc['title'],
      date: doc['date'],
      description: doc['description'],
    );
  }
}

// Main Announcement List Screen
class AnnouncementListScreen extends StatefulWidget {
  @override
  _AnnouncementListScreenState createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  final CollectionReference announcementsCollection =
      FirebaseFirestore.instance.collection('Announcement');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: announcementsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No announcements found.'));
          }

          final announcements = snapshot.data!.docs
              .map((doc) => Announcement.fromFirestore(doc))
              .toList();

          return ListView.builder(
  itemCount: announcements.length,
  itemBuilder: (context, index) {
    final announcement = announcements[index];
    return ListTile(
      leading: Icon(Icons.circle, size: 13), // Dot icon
      title: Text(
                '   ${announcement.title}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementDetailScreen(
              announcement: announcement,
              onDelete: () {
                deleteAnnouncement(announcement.id);
                Navigator.pop(context);
              },
              onEdit: (editedAnnouncement) {
                editAnnouncement(announcement.id, editedAnnouncement);
              },
            ),
          ),
        );
      },
    );
  },
);

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAnnouncementScreen(onSubmit: addAnnouncement),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Add a new announcement to Firestore
  void addAnnouncement(Announcement announcement) async {
    await announcementsCollection.add({
      'title': announcement.title,
      'date': announcement.date,
      'description': announcement.description,
    });
  }

  // Delete an announcement from Firestore
  void deleteAnnouncement(String id) async {
    await announcementsCollection.doc(id).delete();
  }

  // Edit an existing announcement in Firestore
  void editAnnouncement(String id, Announcement editedAnnouncement) async {
    await announcementsCollection.doc(id).update({
      'title': editedAnnouncement.title,
      'date': editedAnnouncement.date,
      'description': editedAnnouncement.description,
    });
  }
}

// Screen to add a new announcement
class AddAnnouncementScreen extends StatelessWidget {
  final Function(Announcement) onSubmit;

  AddAnnouncementScreen({required this.onSubmit});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Announcement'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Announcement'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final announcement = Announcement(
                  id: '', // Firestore will generate the ID
                  title: titleController.text,
                  date: dateController.text,
                  description: descriptionController.text,
                );
                onSubmit(announcement);
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen to display and edit announcement details
class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;
  final Function onDelete;
  final Function(Announcement) onEdit;

  AnnouncementDetailScreen({
    required this.announcement,
    required this.onDelete,
    required this.onEdit,
  });

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = announcement.title;
    dateController.text = announcement.date;
    descriptionController.text = announcement.description;

    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${announcement.title}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Date: ${announcement.date}'),
            SizedBox(height: 10),
            Text('Description: ${announcement.description}'),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    onDelete();
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                ),
                SizedBox(width: 10),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
