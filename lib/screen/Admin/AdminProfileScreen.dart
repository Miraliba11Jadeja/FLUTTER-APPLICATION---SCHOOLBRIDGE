import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool isEditing = false;

  // Image-related variables
  File? _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Controllers to manage text field inputs
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController contactController;
  late TextEditingController genderController;
  late TextEditingController aadharController;

  late TextEditingController permanentAddressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pinCodeController;
  late TextEditingController presentAddressController;
  late TextEditingController countryController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty values
    nameController = TextEditingController();
    emailController = TextEditingController();
    dobController = TextEditingController();
    contactController = TextEditingController();
    genderController = TextEditingController();
    aadharController = TextEditingController();

    permanentAddressController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pinCodeController = TextEditingController();
    presentAddressController = TextEditingController();
    countryController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    contactController.dispose();
    genderController.dispose();
    aadharController.dispose();

    permanentAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    presentAddressController.dispose();
    countryController.dispose();

    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToStorage(String adminId) async {
  if (_profileImage == null) return;

  try {
    // Create a reference to the location in Firebase Storage
    String fileName = 'admin_${adminId}_profile_image.jpg';  // Fix: Use the adminId value correctly
    Reference storageRef = FirebaseStorage.instance.ref().child('profileImages/$fileName');

    // Upload the image file
    UploadTask uploadTask = storageRef.putFile(_profileImage!);
    TaskSnapshot snapshot = await uploadTask;

    // Get the image URL after upload
    String imageUrl = await snapshot.ref.getDownloadURL();

    // Update the Firestore database with the new image URL
    await FirebaseFirestore.instance.collection('Admin').doc(adminId).update({
      'Image': imageUrl,
    });

    setState(() {
      _profileImageUrl = imageUrl;  // Update the local variable with the new image URL
    });

    // Notify the user of the successful upload
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile image updated successfully!')));
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png', // Make sure the path is correct
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text('Admin Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Admin').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Assuming you're working with a single admin document
          var adminData = snapshot.data!.docs.first; // Get the first document in the 'admin' collection
          String adminId = adminData.id; // Store admin ID for future updates
          _profileImageUrl = adminData['Image'];

          // Update text field controllers with Firestore data
          nameController.text = adminData['Name'] ?? '';   
          emailController.text = adminData['Email'] ?? ''; 
          dobController.text = adminData['DOB'] ?? '';     
          contactController.text = adminData['Contact'] ?? '';
          genderController.text = adminData['Gender'] ?? '';
          aadharController.text = adminData['Aadhar'] ?? '';
          permanentAddressController.text = adminData['PermanentA'] ?? '';
          cityController.text = adminData['City'] ?? '';
          stateController.text = adminData['State'] ?? '';
          pinCodeController.text = adminData['Pincode'] ?? '';
          presentAddressController.text = adminData['PresentA'] ?? '';
          countryController.text = adminData['Country'] ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Profile Picture Section
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null 
                        ? FileImage(_profileImage!) 
                        : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) 
                            ? NetworkImage(_profileImageUrl!) as ImageProvider
                            : null,
                    child: _profileImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty)
                        ? Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showImageSourceActionSheet(context, adminId);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'Change Profile Picture',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Personal Details Section
                  buildSectionTitle('PERSONAL DETAILS'),
                  buildDetailsRow('Name', nameController, 'Email', emailController),
                  buildDetailsRow('Date Of Birth', dobController, 'Contact No', contactController),
                  buildDetailsRow('Gender', genderController, 'Aadhar No.', aadharController),

                  SizedBox(height: 20),

                  // Contact Details Section
                  buildSectionTitle('CONTACT DETAILS'),
                  buildDetailsRow('Permanent Address', permanentAddressController, 'City', cityController),
                  buildDetailsRow('State', stateController, 'PinCode', pinCodeController),
                  buildDetailsRow('Present Address', presentAddressController, 'Country', countryController),

                  SizedBox(height: 40),

                  // Edit/Save Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isEditing) {
                          // Save the updated data
                          FirebaseFirestore.instance.collection('Admin').doc(adminId).update({
                            'Name': nameController.text,
                            'Email': emailController.text,
                            'DOB': dobController.text,
                            'Contact': contactController.text,
                            'Gender': genderController.text,
                            'Aadhar': aadharController.text,
                            'PermanentA': permanentAddressController.text,
                            'City': cityController.text,
                            'State': stateController.text,
                            'Pincode': pinCodeController.text,
                            'PresentA': presentAddressController.text,
                            'Country': countryController.text,
                          });
                        }
                        isEditing = !isEditing; // Toggle the editing state
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF134B70), 
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save' : 'Edit Profile',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context, String adminId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                  await _uploadImageToStorage(adminId); // Upload the selected image
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                  await _uploadImageToStorage(adminId); // Upload the captured image
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widget to build a title for sections
  Widget buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  // Helper widget to build a row of details with editable text fields
 Widget buildDetailsRow(String label1, TextEditingController controller1, String label2, TextEditingController controller2) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // First Column (Label1 and Value1)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,  // Bold field label
                  fontSize: 16,                 // Adjust font size if needed
                ),
              ),
              SizedBox(height: 8),  // Space between label and value
              isEditing
                  ? TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                        border: InputBorder.none,  // No border for TextField
                      ),
                    )
                  : Text(
                      controller1.text,
                      style: TextStyle(fontSize: 16),  // Style the value text if needed
                    ),
            ],
          ),
        ),
        
        SizedBox(width: 20), // Space between the two columns
        
        // Second Column (Label2 and Value2)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,  // Bold field label
                  fontSize: 16,                 // Adjust font size if needed
                ),
              ),
              SizedBox(height: 8),  // Space between label and value
              isEditing
                  ? TextField(
                      controller: controller2,
                      decoration: InputDecoration(
                        border: InputBorder.none,  // No border for TextField
                      ),
                    )
                  : Text(
                      controller2.text,
                      style: TextStyle(fontSize: 16),  // Style the value text if needed
                    ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
