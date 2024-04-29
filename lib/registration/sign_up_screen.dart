import 'dart:convert';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/registration/admin_sign_up.dart';

import '../security/login_screen.dart';
import 'registration_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? password;
  String? confirmPassword;
  bool _obscureText = true;
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final bestFriendController = TextEditingController();
  String? groupValue;
  bool? _isChecked = false;
  Future<String>? signupResult;
  Future<String>? signupAuthResult;
  Future<String>? signupAuthPhoneResult;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    bestFriendController.dispose();
    super.dispose();
  }

  Future<String> signUpAuth() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/signUpAuth.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "Phone": phoneController.text,
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      return 'sign up failed: $e';
    }
  }

  Future<String> signUpPhoneAuth() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/signUpPhoneAuth.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "Phone": phoneController.text,
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      return 'sign up failed: $e';
    }
  }

  Future<String> signUp() async {
    try {
      if (passwordConfirmed()) {
        String url = "http://127.0.0.1/stokvel_api/signupdbconnection.php";
        dynamic response = await http.post(Uri.parse(url), body: {
          "Phone": phoneController.text,
          "Username": usernameController.text,
          "Password": passwordController.text,
          "Gender": groupValue,
          "BestFriend": bestFriendController.text
        });
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data == "Error") {
            return 'Error';
          } else {
            return 'Success';
          }
        } else {
          return 'Request failed with status: ${response.statusCode}';
        }
      } else {
        return 'Passwords do not match';
      }
    } catch (e) {
      return 'Failed to create account: $e';
    }
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  String validatePhoneNumber(String phoneNumber) {
    final RegExp phoneRegExp = RegExp(r'^[(76)/(78)/(79)]\d{7}$');
    if (!phoneRegExp.hasMatch(phoneNumber)) {
      if (phoneNumber.length < 8) {
        return 'Phone number is too short';
      } else {
        return 'Invalid Phone number\nshould start with 7 (6/8/9)';
      }
    }
    return 'Valid';
  }

  void storePhone(String phoneController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phoneController);
  }

  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sign Up Screen",
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
                      children: <Widget>[
                        Image.asset(
                          "images/signupnow.jpeg",
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        const SizedBox(height: 5.0),
                        const Text(
                          "Hello, \nLet's create an account for you",
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sign up/create account:",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: "create username",
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
                            } else if (value.length < 6 || value.length > 10) {
                              return 'Username must be between 6 and 10 characters';
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: "+268 7......",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                            labelText: "Phone",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            prefixIcon: Icon(Icons.phone, color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter phone number";
                            }

                            final String validationResult =
                                validatePhoneNumber(value);
                            if (validationResult != 'Valid') {
                              return validationResult;
                            }
                            return null;
                          },
                          maxLength: 8,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "create password",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
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
                          controller: confirmPasswordController,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "confirm your password",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
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
                        Row(
                          children: [
                            const Text(
                              "Gender",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(width: 20),
                            Radio(
                              value: "Male",
                              groupValue: groupValue,
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value!;
                                });
                              },
                            ),
                            const Text("Male"),
                            const SizedBox(width: 10),
                            Radio(
                              value: "Female",
                              groupValue: groupValue,
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value!;
                                });
                              },
                            ),
                            const Text("Female"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "let's secure your account",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: bestFriendController,
                          decoration: const InputDecoration(
                            hintText: "your friend second name/nickname",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                            labelText: "What is your friend second name?",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "friend name can't be empty";
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                                value: _isChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isChecked = newValue;
                                  });
                                }),
                            const Text("Accept"),
                            const SizedBox(width: 1),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  _context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsOfUse(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Terms of Use",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 400.0,
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ElevatedButton(
                            onPressed: _isChecked!
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      var signupAuthResult = signUpAuth();
                                      signupAuthResult.then((result) async {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (result != 'Success') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Row(
                                                  children: [
                                                    Icon(Icons.close,
                                                        color: Colors.red),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "Error",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                                content: const Text(
                                                  "Access denied \nplease contact admin",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("OK"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _formKey.currentState!
                                                          .reset();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          var signupAuthPhoneResult =
                                              signUpPhoneAuth();
                                          signupAuthPhoneResult.then(
                                            (result) async {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              if (result == 'Success') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Row(
                                                        children: [
                                                          Icon(Icons.close,
                                                              color:
                                                                  Colors.red),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            "Error",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ],
                                                      ),
                                                      content: const Text(
                                                        "Account already exist with this phone number\nTry another phone",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text("OK"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                var signupResult = signUp();
                                                signupResult.then(
                                                  (result) async {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    if (result != 'Success') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .red),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "Error",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ],
                                                            ),
                                                            content: const Text(
                                                              "Failed to create account\nPlease try again",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        "OK"),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  _formKey
                                                                      .currentState!
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
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "Account \ncreated successfully",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ],
                                                            ),
                                                            content: const Text(
                                                                "Please continue and \ncomplete your registration"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        "OK"),
                                                                onPressed: () {
                                                                  storePhone(
                                                                      phoneController
                                                                          .text);
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return RegistrationForm(
                                                                            phoneNumber:
                                                                                phoneController.text);
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
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        }
                                      });
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.blue),
                            ),
                            child: const Text("CREATE ACCOUNT"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Are you admin/tressurer?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(width: .2),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const AdminSignUpScreen();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Register here.",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(width: .2),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const LoginScreen();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Login...",
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

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Terms of use"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Terms of Use",
                  style: TextStyle(
                    fontSize: 28.0,
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "\n\nWelcome to Stokvel banking and chat app! \nBy using this app, you agree to the following terms and conditions:"
                    "\n\n1. Account Registration: \n      You must register an account with us to use our app. You agree to provide accurate and complete information during the registration process."
                    "\n\n2. User Conduct: \n      You agree to use our app only for lawful purposes and in a manner that does not infringe the rights of, or restrict or inhibit the use and purpose of, our app by any third party."
                    "\n\n3. Security: \n      You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device. You agree to accept responsibility for all activities that occur under your account or password."
                    "\n\n4. Intellectual Property: \n     Our app and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws."
                    "\n\n5. Limitation of Liability: \n     In no event shall we be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from; \n(i) your access to or use of or inability to access or use the app \n(ii) any conduct or content of any third party on the app \n(iii) any content obtained from the app and \n(iv) unauthorized access, use, or alteration of your transmissions or content, whether based on warranty, contract, tort (including negligence), or any other legal theory, whether or not we have been informed of the possibility of such damage, and even if a remedy set forth herein is found to have failed of its essential purpose."
                    "\n\n6. Governing Law: \n     These terms and conditions shall be governed by and construed in accordance with the laws of the country in which we are located, without giving effect to any principles of conflicts of law."
                    "\n\n7. Changes to Terms and Conditions: \n     We reserve the right, at our sole discretion, to modify or replace these terms and conditions at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion."
                    "\n\n8. Contact Us: \n      If you have any questions about these terms and conditions, please contact us via celphone: +268 76416393 or send us an email at cityunitedstokvel@gmail.com."
                    "\n\n\nThank you for using our app!\n",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
