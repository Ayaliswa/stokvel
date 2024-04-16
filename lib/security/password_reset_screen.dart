import 'dart:convert';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/security/login_screen.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  PasswordResetScreenState createState() => PasswordResetScreenState();
}

class PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Future<String>? resetAuthResult;
  bool _isLoading = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> resetPasswordAuth() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/resetPasswordAuth.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "username": usernameController.text,
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
      print('Exception in resetPasswordAuth: $e');
      return 'Passsword reset authentication failed: $e';
      //return 'Password reset authentication failed: ${e.toString()}';
    }
  }

  void storeUsername(String usernameController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Screen",
      home: Stack(
        children: [
          Image.asset(
            "images/background3.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Center(
                child: Text('Failed to load image'),
              );
            },
          ),
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colors.blue,
              ),
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Center(
              child: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/passforgoten.jpeg",
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        const SizedBox(height: 5.0),
                        const Text(
                          "Forgot Password?\nSumbit the form below to reset your password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            hintText: "Username or Phone",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                            labelText: "Username",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter username";
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.text,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "second name/nickname",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                            labelText: "What is your friend second name?",
                            labelStyle: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            prefixIcon: const Icon(Icons.group_add,
                                color: Colors.black),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "best friend name can't be empty";
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          width: 400.0,
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                resetAuthResult = resetPasswordAuth();
                                resetAuthResult?.then((result) async {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (result != 'Success') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Error",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: const Row(
                                            children: [
                                              Icon(Icons.error_outline,
                                                  color: Colors.red),
                                              Text(
                                                "The username and friend name match was not found",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("Try again"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                usernameController.clear();
                                                passwordController.clear();
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
                                          title: const Text(
                                            "",
                                          ),
                                          content: const Text(
                                              "Please continue to reset your password"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("Continue"),
                                              onPressed: () {
                                                storeUsername(
                                                    usernameController.text);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return const ChangePassword();
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
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                            child: const Text("SUBMIT"),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Back to login!",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
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
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  Future<String>? resetResult;
  bool _isLoading = false;
  String? password;
  String? confirmPassword;
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController newPassConfController = TextEditingController();

  Future<String> resetPassword() async {
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
      print('Exception in forgotPass: $e');
      return 'Passsword reset failed: $e';
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
          body: Center(
            child: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/newpass.jpeg",
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Create New Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: newPassController,
                        obscureText: _obscureText,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "create password",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          labelText: "Password",
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          prefixIcon:
                              const Icon(Icons.vpn_key, color: Colors.black),
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
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 8 || value.length > 15) {
                            return 'Password must be at least 8 characters long\n and not more than 15';
                          }
                          return null;
                        },
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: newPassConfController,
                        obscureText: _obscureText,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "confirm your new password",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          labelText: "Confirm Password",
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
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty || value != password) {
                            return "Password do not match";
                          }
                          if (password == null) {
                            return 'Please confirm your password';
                          }
                          return null;
                        },
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
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
                              var resetResult = resetPassword();
                              resetResult.then((result) async {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (result != 'Success') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error"),
                                        content:
                                            const Text("Password reset failed"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Try again"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _formKey.currentState!.reset();
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
                                                  builder:
                                                      (BuildContext context) {
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
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: const Text("RESET PASSWORD"),
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
