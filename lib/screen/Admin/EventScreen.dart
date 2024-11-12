import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:io';

class EventScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EVENTS"),
        backgroundColor: Color(0xFF134B70),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Menu functionality
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final events = snapshot.data!.docs;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index].data() as Map<String, dynamic>;

              // Format the date
              String formattedDate = event['date'] != null
                  ? DateFormat('dd-MM-yyyy').format(DateTime.parse(event['date']))
                  : 'No Date';

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: event['image'] != null
                      ? Image.network(
                          event['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image, size: 50),
                  title: Text(event['eventName'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formattedDate),
                      SizedBox(height: 4),
                      Text(event['location'] ?? 'No Location'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventScreen()),
          );
        },
      ),
    );
  }
}

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<void> _submitEvent() async {
    // Validate input fields
    if (_eventNameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _selectedDate == null ||
        _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    try {
      // Upload image to Firebase Storage and get the URL (you'll need to implement this part)
      // String imageUrl = await uploadImageToFirebaseStorage(_pickedImage!);

      // For now, use the local image path (this should be replaced with imageUrl from Firebase Storage)
      String imageUrl = _pickedImage!.path;

      // Add event to Firestore
      await FirebaseFirestore.instance.collection('events').add({
        'eventName': _eventNameController.text.trim(),
        'location': _locationController.text.trim(),
        'date': _selectedDate!.toIso8601String(),
        'image': imageUrl, // Store the URL of the uploaded image
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event added successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
        backgroundColor: Color(0xFF134B70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      hintText: _selectedDate == null
                          ? 'DD/MM/YYYY'
                          : DateFormat('dd-MM-yyyy').format(_selectedDate!),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  if (_pickedImage != null)
                    Image.file(
                      _pickedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  else
                    Icon(Icons.image, size: 100),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Choose Image'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEvent,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
