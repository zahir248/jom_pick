import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController icNumber = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController matriculationNumber = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  String? _userType; // to store the selected user type


  Future register() async {

    if (user.text.isEmpty ||
        pass.text.isEmpty ||
        confirmPass.text.isEmpty ||
        fullName.text.isEmpty ||
        emailAddress.text.isEmpty ||
        icNumber.text.isEmpty ||
        phoneNumber.text.isEmpty) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Please fill in all the fields',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else if (pass.text != confirmPass.text) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Passwords did not match',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {

      var url = Uri.http(MyApp.baseIpAddress, MyApp.registerPath, {'q': '{http}'});

      var response = await http.post(url, body: {
        "username": user.text.toString(),
        "password": pass.text.toString(),
        "fullName": fullName.text.toString(),
        "emailAddress": emailAddress.text.toString(),
        "icNumber": icNumber.text.toString(),
        "phoneNumber": phoneNumber.text.toString(),
        "matricNumber": matriculationNumber.text.toString(),
        "userType": _userType.toString(), // Include userType in the request
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        Fluttertoast.showToast(
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          msg: 'User already exists!',
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.green,
          textColor: Colors.white,
          msg: 'Registration Successful',
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      }
    }
  }

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false; // Add a new boolean variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50, 16.0, 0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 1.0, 16.0, 10.0),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0), // Adjust the bottom padding
                  child: TextFormField(
                      controller: fullName,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                      ),
                      validator: (value){
                        if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value!) || RegExp(r'^[0-9]+$').hasMatch(value!)){
                          return 'Invalid format for name';
                        }else{
                          return null;
                        }
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Choose One:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                // Small text below "Choose One" for the note about "Public" role
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '(Public don\'t need to put Matric number)',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                // Radio buttons for user type arranged horizontally
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: 'student',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value.toString();
                            });
                          },
                        ),
                        Text('Student'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'staff',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value.toString();
                            });
                          },
                        ),
                        Text('Staff'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'public',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value.toString();
                            });
                          },
                        ),
                        Text('Public'),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                      controller: matriculationNumber,
                      decoration: InputDecoration(
                        labelText: 'Matric Number',
                      ),
                      validator: (value){
                        if(value!.isEmpty || RegExp(r'^[a-z A-Z]+$').hasMatch(value!) || RegExp(r'^[0-9]+$').hasMatch(value!)){
                          return 'Invalid format for matric number';
                        }else{
                          return null;
                        }
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: icNumber,
                      decoration: InputDecoration(
                        labelText: 'IC Number',
                      ),
                      validator: (value){
                        if(value!.isEmpty || RegExp(r'^[a-z A-Z]+$').hasMatch(value!) || !RegExp(r'^[0-9]+$').hasMatch(value!) || value.length>12){
                          return 'IC Number must contains 12 digit wihout "-"';
                        }else{
                          return null;
                        }
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    validator: (value){
                      // Asserts the value to non-null
                      if(!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value!)){
                        return 'Invalid format for email';
                      };
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      validator: (value){
                        if(value!.isEmpty || RegExp(r'^[a-z A-Z]+$').hasMatch(value!) || !RegExp(r'^[0-9]+$').hasMatch(value!) ||value.length>11 || value.length<10){
                          return 'Invalid phone number';
                        }else{
                          return null;
                        }
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                      controller: user,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value){
                        if(value!.isEmpty || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value) || value.length<8){
                          return 'Username must contains at lower case, upper case, number and at least 8 character';
                        }else{
                          return null;
                        }
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                      controller: pass,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty || !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_-]).+$').hasMatch(value) || value.length<8){
                          return 'Password must contains at lower case, upper case, number, special character and at least 8 character';
                        }else{
                          return null;
                        }
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: confirmPass,
                    obscureText: !isConfirmPasswordVisible, // Use the new variable
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isConfirmPasswordVisible =
                            !isConfirmPasswordVisible;
                          });
                        },
                        child: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Check if form data is valid
                    if(_formKey.currentState!.validate()){
                      register();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50), // Adjust the width and height as needed
                  ),
                  child: Text('Register', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}