import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool isEditing = false;

  // Initial profile data
  String name = 'ABCD';
  String email = 'abc@def.com';
  String dob = 'DD/MM/YYYY';
  String contactNo = '1234567890';
  String gender = 'Male/Female';
  String aadharNo = 'ABCDBD123456';

  String permanentAddress = 'ABCD, House Name, Landmark';
  String city = 'Rajkot';
  String state = 'Gujarat';
  String pinCode = '360020';
  String presentAddress = 'ABCD, House Name, Landmark';
  String country = 'India';

  // Image-related variables
  File? _profileImage;
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

    // Initialize controllers with current data
    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
    dobController = TextEditingController(text: dob);
    contactController = TextEditingController(text: contactNo);
    genderController = TextEditingController(text: gender);
    aadharController = TextEditingController(text: aadharNo);

    permanentAddressController = TextEditingController(text: permanentAddress);
    cityController = TextEditingController(text: city);
    stateController = TextEditingController(text: state);
    pinCodeController = TextEditingController(text: pinCode);
    presentAddressController = TextEditingController(text: presentAddress);
    countryController = TextEditingController(text: country);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Admin Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Picture Section
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showImageSourceActionSheet(context);
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
                      name = nameController.text;
                      email = emailController.text;
                      dob = dobController.text;
                      contactNo = contactController.text;
                      gender = genderController.text;
                      aadharNo = aadharController.text;

                      permanentAddress = permanentAddressController.text;
                      city = cityController.text;
                      state = stateController.text;
                      pinCode = pinCodeController.text;
                      presentAddress = presentAddressController.text;
                      country = countryController.text;
                    }
                    isEditing = !isEditing; // Toggle the editing state
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF134B70), // Background color of the button
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
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper function to build section title
  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF134B70),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper function to build a row of details with two items per row
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isEditing
                    ? TextField(controller: controller1)
                    : Text(controller1.text),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isEditing
                    ? TextField(controller: controller2)
                    : Text(controller2.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
