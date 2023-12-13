import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jom_pick/register.dart';
import 'package:http/http.dart' as http;
import 'DashBoard.dart';
import 'package:flutter/gestures.dart';
import 'splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'admin.dart';
import 'security_questions.dart';

void main() {
  runApp(const MyApp());
  GeolocatorPlatform.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final String baseIpAddress = "10.200.124.64";

  static final String loginPath = "/jompick/login.php";
  static final String registerPath = "/jompick/register.php";
  static final String updateProfilePath = "/jompick/updateProfile.php";
  static final String updateConfirmationDurationLocationPath = "/jompick/updateConfirmationDurationLocation.php";
  static final String updateConfirmationStatusPath = "/jompick/updateConfirmationStatus.php";
  static final String updatePickupDatePath = "/jompick/updateConfirmationPickupDate.php";
  static final String itemPenaltyPath = "/jompick/itemPenalty.php";
  static final String updateConfirmationDatePath = "/jompick/updateConfirmationDate.php";
  static final String itemHistoryPath = "/jompick/itemHistory.php";
  static final String updateForgotPasswordPath = "/jompick/forgotPassword.php";
  static final String itemHomePath = "/jompick/itemHome.php";
  static final String updatePasswordPath = "/jompick/updatePassword.php";
  static final String verifySecurityQuestions = "/jompick/verifySecurityQuestions.php";

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
    if (user.text.isEmpty || pass.text.isEmpty) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Please enter both username and password',
        toastLength: Toast.LENGTH_SHORT,
      );
      return; // Exit the function to prevent further execution
    }

    var url = Uri.http(MyApp.baseIpAddress, MyApp.loginPath, {'q': '{http}'});
    var response = await http.post(url, body: {
      "username": user.text,
      "password": pass.text,
    });

    if (response.statusCode == 200) {
      // Check if the response body is not empty
      if (response.body.isNotEmpty) {
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

              if (data.containsKey('image')) {
                // Save the image locally and store its path in SharedPreferences
                String imageBase64 = data['image'];
                List<int> imageBytes = base64.decode(imageBase64);
                String imagePath = await _saveImageLocally(imageBytes, userId!);
                prefs.setString('imagePath', imagePath);
              }

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

              // Check for the role information and redirect accordingly
              if (data.containsKey('rolename')) {
                String rolename = data['rolename'];
                if (rolename == 'admin' || rolename == 'staff') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPage(username: user.text), // Pass the username here
                    ),                  );
                } else if (rolename == 'student' || rolename == 'public') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoard()),
                  );
                } else {
                  print('Unknown rolename: $rolename');
                }
              } else {
                print('rolename not found in response');
              }
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
            msg: 'Invalid Username or Password',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      } else {
        print('Empty response body');
        // Handle the case of an empty response body
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
      // Handle the case of a failed HTTP request
    }
  }

  Future<String> _saveImageLocally(List<int> imageBytes, int userId) async {
    // Save the image in the app's cache directory with a filename based on the user's ID
    String cacheDirPath = (await getTemporaryDirectory()).path;
    String imagePath = '$cacheDirPath/profile_image_$userId.png';

    // Write the image bytes to the file
    await File(imagePath).writeAsBytes(imageBytes);

    return imagePath;
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
                'assets/jompick2.png',
                width: 300,
                height: 300,
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
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
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
                  fixedSize: Size(340, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text('Login', style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecurityQuestions()),
                  );
                },
                child: Text(
                  'Forgot password',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
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

