import 'package:flutter/material.dart';
import 'package:jom_pick/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dashboard.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String fullName = ''; // Initialize with user's full name
  String phoneNumber = ''; // Initialize with user's phone number
  String icNumber = ''; // Initialize with user's IC number
  String email = ''; // Initialize with user's email

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController icNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load user details from SharedPreferences or another data source
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? ''; // Replace with the actual key used to store full name
      phoneNumber = prefs.getString('phoneNumber') ?? ''; // Replace with the actual key used to store phone number
      icNumber = prefs.getString('icNumber') ?? ''; // Replace with the actual key used to store IC number
      email = prefs.getString('email') ?? ''; // Replace with the actual key used to store email
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Redirects to the dashboard page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildEditableProfileField('Full Name', fullName, Icons.edit, fullNameController),
            buildEditableProfileField('Phone Number', phoneNumber, Icons.edit, phoneNumberController),
            buildEditableProfileField('IC Number', icNumber, Icons.edit, icNumberController),
            buildEditableProfileField('Email', email, Icons.edit, emailController),
            SizedBox(height: 10), // Add space between the second and third buttons
            Container(
                width: 300, // Set a fixed width for all the buttons, you can adjust this value
                child:ElevatedButton(
                   onPressed: () {
                   // Handle the update action here
                   updateProfile();
                   },
                   child: Text('Update',
                   style: TextStyle(fontSize: 15), // Increase the font size here
                ),
            )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableProfileField(String title, String value, IconData iconData, TextEditingController controller) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: IconButton(
        icon: Icon(iconData),
        onPressed: () {
          // Set the corresponding controller text when the user taps the edit icon
          controller.text = value;
        },
      ),
    );
  }

  void updateProfile() {
    // Handle the update action here:
    // You can access the updated values from the controllers (fullNameController, phoneNumberController, etc.)
    String updatedFullName = fullNameController.text;
    String updatedPhoneNumber = phoneNumberController.text;
    String updatedICNumber = icNumberController.text;
    String updatedEmail = emailController.text;

    // You can save the updated values to SharedPreferences or your data source
    // Then, update the displayed values
  }
}





