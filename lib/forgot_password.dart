import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  Future<void> updatePassword() async {
    try {
      final response = await http.post(
        Uri.http('192.168.0.113', '/forgotPassword.php', {'q': '{http}'}),
        body: {
          'username': usernameController.text,
          'emailAddress': emailController.text,
          'newPassword': newPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success']) {
          showToastMessage(
            'Password updated successfully',
            Colors.green,
          );

          setState(() {
            usernameController.clear();
            emailController.clear();
            newPasswordController.clear();
            confirmPasswordController.clear();
          });
        } else {
          showToastMessage(
            responseData['message'] ?? 'Failed to update password',
            Colors.red,
          );
        }
      } else {
        showToastMessage(
          'Failed to update password',
          Colors.red,
        );
      }
    } catch (error) {
      print('Error updating password: $error');
    }
  }

  Future<void> checkAndSave() async {
    try {
      if (newPasswordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        if (newPasswordController.text == confirmPasswordController.text) {
          // Call the function to check and update the password
          await updatePassword();
        } else {
          showToastMessage('Passwords did not match', Colors.red);
        }
      } else {
        Fluttertoast.showToast(msg: 'No changes to update');
      }
    } catch (error) {
      print('Error in checkAndSave: $error');
    }
  }

  void showToastMessage(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 50, 16.0, 0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 1.0, 16.0, 10.0),
              child: Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
              child: TextField(
                controller: usernameController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
              child: TextField(
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Email address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
              child: TextField(
                controller: newPasswordController,
                obscureText: !isNewPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isNewPasswordVisible = !isNewPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: checkAndSave,
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(340, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text('Update Password', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
