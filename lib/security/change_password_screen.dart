import 'dart:convert';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  Future<String>? authResult;
  Future<String>? changeResult;
  bool _isLoading = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController newPassConfController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    newPassController.dispose();
    newPassConfController.dispose();
    super.dispose();
  }

  Future<String> changePasswordAuth() async {
    try {
      String username = await getUsername();
      String url = "http://127.0.0.1/stokvel_api/changePasswordAuth.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "username": username,
        "password": passwordController.text,
      });
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      print('Exception in changePasswordAuth: $e');
      return 'Passsword change authentication failed: $e';
      //return 'Password reset authentication failed: ${e.toString()}';
    }
  }

  Future<String> changePassword() async {
    try {
      String username = await getUsername();
      String url = "http://127.0.0.1/stokvel_api/resetPassword.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "username": username,
        "password": newPassController.text,
      });
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      print('Exception in changePassword: $e');
      return 'Passsword change failed: $e';
      //return 'Password reset failed: ${e.toString()}';
    }
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("Change Password"),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/icon.png",
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Update to New Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "enter current password",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          labelText: "Password",
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          prefixIcon:
                              const Icon(Icons.key, color: Colors.black),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 200.0,
                        height: 1,
                        color: Colors.black,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: newPassController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "create your new password",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          labelText: "New Password",
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          prefixIcon:
                              const Icon(Icons.key, color: Colors.black),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: newPassConfController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "corfirm your password",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          labelText: "Confirm New Password",
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.black),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: 400.0,
                        height: 40,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              var authResult = changePasswordAuth();
                              authResult.then((result) async {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (result != 'Success') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error"),
                                        content: const Text(
                                            "Failed to change password\ncurrent password is incorrect"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Try again"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  var changeResult = changePassword();
                                  changeResult.then((result) async {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (result != 'Success') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Error"),
                                            content: const Text(
                                                "Something went wrong\npassword not changed"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Try again"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _formKey.currentState!
                                                      .reset();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Success"),
                                            content: const Text(
                                                "Password changed successfully\nLogin with your new password"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Login"),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return const LoginScreen();
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: const Text("CHANGE PASSWORD"),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
