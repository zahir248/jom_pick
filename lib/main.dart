import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jom_pick/register.dart';
import 'package:http/http.dart' as http;
import 'DashBoard.dart';
import 'package:flutter/gestures.dart'; // Add this import
import 'splashscreen.dart'; // Import your splash screen
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JomPick',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async {
    var url = Uri.http("10.200.90.242", '/login.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "username": user.text,
      "password": pass.text,
    });
    var data = json.decode(response.body);

    if (data["status"] == "Success") {
      Fluttertoast.showToast(
        msg: 'Login Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      // Save user session data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', user.text);

      if (data.containsKey('user_id')) {
        int? userId = int.tryParse(data['user_id']);
        if (userId != null) {
          prefs.setInt('user_id', userId);

          if (data.containsKey('icNumber')) {
            String icNumber = data['icNumber'];
            prefs.setString('icNumber', icNumber);
          }

          if (data.containsKey('fullName')) {
            String fullName = data['fullName'];
            prefs.setString('fullName', fullName);
          }

          if (data.containsKey('phoneNumber')) {
            String phoneNumber = data['phoneNumber'];
            prefs.setString('phoneNumber', phoneNumber);
          }

          if (data.containsKey('emailAddress')) {
            String emailAddress = data['emailAddress'];
            prefs.setString('emailAddress', emailAddress);
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashBoard(),
            ),
          );
        } else {
          print('Failed to parse user_id as int');
        }
      } else {
        print('user_id not found in response');
      }
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Username and password invalid',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/jompick.jpg', // Replace with your image path
                width: 300, // Adjust the width as needed
                height: 300, // Adjust the height as needed
              ),
              const SizedBox(height: 20),
              Text(
                'Login',
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
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 16, // You can adjust the font size as needed
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        fontSize: 16, // You can adjust the font size as needed
                        color: Colors.blue,
                        decoration: TextDecoration.underline, // Add underline to make it look like a link
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Add your navigation logic here when "Sign Up" is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Register()),
                          );
                        },
                    ),
                  ],
                ),

              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 50), // Adjust the width and height as needed
                ),
                child: Text('Login', style: TextStyle(fontSize: 18)), // Adjust the font size as needed
              ),
              TextButton(
                onPressed: () {
                },
                child: Text(
                  'Forgot password',
                  style: TextStyle(
                    decoration: TextDecoration.underline, // Add underline to make it look like a link
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
