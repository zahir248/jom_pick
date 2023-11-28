import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dashboard.dart';
import 'penalty.dart';
import 'history.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';  // Import this for File
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3; // Index of the selected tab
  String icNumber = ''; // Variable to store the IC number
  int? userId;
  String fullName = ''; // Variable to store the full name
  String phoneNumber = ''; // Variable to store the phone number
  String emailAddress = ''; // Variable to store the email address
  String username = ''; // Variable to store the email address
  String imagePath = ''; // Variable to store the image path

  @override
  void initState() {
    super.initState();
    getSharedDataFromSharedPreferences();
  }

  Future<void> getSharedDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    String? storedIcNumber = prefs.getString('icNumber');
    String? storedFullName = prefs.getString('fullName');
    String? storedPhoneNumber = prefs.getString('phoneNumber');
    String? storedEmailAddress = prefs.getString('emailAddress');
    String? storedUsername = prefs.getString('username');
    String? storedImagePath = prefs.getString('imagePath');

    if (storedIcNumber != null) {
      setState(() {
        icNumber = storedIcNumber;
      });
    }
    if (storedFullName != null) {
      setState(() {
        fullName = storedFullName;
      });
    }
    if (storedPhoneNumber != null) {
      setState(() {
        phoneNumber = storedPhoneNumber;
      });
    }
    if (storedEmailAddress != null) {
      setState(() {
        emailAddress = storedEmailAddress;
      });
    }
    if (storedUsername != null) {
      setState(() {
        username = storedUsername;
      });
    }
    if (storedImagePath != null) {
      setState(() {
        imagePath = storedImagePath;
      });
    }
  }

  Future<void> _showEditDialog(String label, String currentValue) async {
    TextEditingController controller = TextEditingController(
        text: currentValue);
    TextInputType keyboardType = TextInputType
        .text; // Default to a text keyboard

    // Set the keyboardType based on the label
    if (label == 'Phone Number' || label == 'IC Number') {
      keyboardType = TextInputType.number;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType, // Set the keyboard type
            decoration: InputDecoration(labelText: label),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Update the respective value based on the label
                setState(() {
                  if (label == 'Full Name') {
                    fullName = controller.text;
                  } else if (label == 'Phone Number') {
                    phoneNumber = controller.text;
                  } else if (label == 'IC Number') {
                    icNumber = controller.text;
                  } else if (label == 'Email Address') {
                    emailAddress = controller.text;
                  }
                });
                // Update SharedPreferences here
                updateSharedPreferences();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProfile() async {
    try {
      // Create a `http.MultipartRequest` to send a combination of text data and image
      var request = http.MultipartRequest(
        'POST',
        Uri.http('192.168.0.113', '/updateProfile.php', {'q': '{http}'}),
      );

      // Attach the image file if imagePath is not empty
      if (imagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('profile_image', imagePath),
        );
      }

      // Attach other data to the request
      request.fields['user_id'] = userId.toString();
      request.fields['fullName'] = fullName;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['icNumber'] = icNumber;
      request.fields['emailAddress'] = emailAddress;

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully updated the profile
        // Parse the JSON response
        final Map<String, dynamic> responseData =
        json.decode(await response.stream.bytesToString());

        if (responseData['success']) {
          // Update was successful, show the toast and update state
          Fluttertoast.showToast(
            backgroundColor: Colors.green,
            textColor: Colors.white,
            msg: 'Profile updated successfully',
            toastLength: Toast.LENGTH_SHORT,
          );

          // Update the state variables directly
          setState(() {
            fullName = responseData['fullName'];
            phoneNumber = responseData['phoneNumber'];
            icNumber = responseData['icNumber'];
            emailAddress = responseData['emailAddress'];
          });

          // Update SharedPreferences here
          updateSharedPreferences();
        } else {
          // Update failed, show an error toast
          Fluttertoast.showToast(msg: 'No changes to update');
        }
      } else {
        // HTTP request failed, show an error toast
        Fluttertoast.showToast(msg: 'Failed to update profile');
      }
    } catch (error) {
      // Handle any exceptions that might occur during the update
      print('Error updating profile: $error');
    }
  }


  void updateSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('icNumber', icNumber);
    prefs.setString('fullName', fullName);
    prefs.setString('phoneNumber', phoneNumber);
    prefs.setString('emailAddress', emailAddress);
    prefs.setString('imagePath', imagePath); // Update imagePath in SharedPreferences
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      // If the "Profile" button is tapped (index 2), navigate to the profile page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Penalty(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => History(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoard(),
        ),
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 50, // Adjust the quality (0 to 100)
      );

      if (image != null) {
        setState(() {
          imagePath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    // Force widget to rebuild
    setState(() {});
  }



  Widget buildProfileField(String label, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        // Add left and right padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Align items at the start and end
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20, // Reduce the font size for the label
                    fontWeight: FontWeight.bold, // Make the label bold
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Show the edit dialog when the edit icon is pressed
                    _showEditDialog(label, value);
                  },
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18, // Font size for the value
              ),
            ),
            SizedBox(height: 15), // Add space between the fields
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                key: UniqueKey(),  // Add this line
                onTap: () {
                  _pickImage();
                },
                child: CircleAvatar(
                  key: UniqueKey(),  // Add this line
                  radius: 70,
                  backgroundImage: imagePath.isNotEmpty && File(imagePath).lengthSync() > 0
                      ? FileImage(File(imagePath)) as ImageProvider<Object>?
                      : AssetImage('assets/default.jpg') as ImageProvider<Object>?,
                ),
              ),
              SizedBox(height: 15),
              Text(
                username,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              buildProfileField('Full Name', fullName),
              buildProfileField('Phone Number', phoneNumber),
              buildProfileField('IC Number', icNumber),
              buildProfileField('Email Address', emailAddress),
              SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    updateProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(340, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.error),
            label: 'Penalty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}