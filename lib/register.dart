import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'DashBoard.dart';
import 'main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController icNumber = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  Future register() async {
    bool isFormValid = true;

    if (user.text.isEmpty || pass.text.isEmpty || fullName.text.isEmpty || emailAddress.text.isEmpty || icNumber.text.isEmpty || phoneNumber.text.isEmpty) {
      isFormValid = false;
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Please fill in all the fields',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      var url = Uri.http("10.200.91.85", '/register.php', {'q': '{http}'});
      var response = await http.post(url, body: {
        "username": user.text.toString(),
        "password": pass.text.toString(),
        "fullName": fullName.text.toString(),
        "emailAddress": emailAddress.text.toString(),
        "icNumber": icNumber.text.toString(),
        "phoneNumber": phoneNumber.text.toString(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Redirects to the previous page (login page)
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: user,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: fullName,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: icNumber,
                  decoration: InputDecoration(
                    labelText: 'Ic Number',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: phoneNumber,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  register();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50), // Adjust the width and height as needed
                ),
                child: Text('Register', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
