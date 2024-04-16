import 'dart:convert';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/bottom_tabs/user/statement.dart';
import 'package:stokvel/registration/admin_sign_up.dart';
import 'package:stokvel/security/admin_password_reset.dart';
import 'package:stokvel/security/login_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Future<String>? loginResult;
  bool _isLoading = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Future<String> adminLogin() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/adminLoginAuth.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "username": usernameController.text,
        "password": passwordController.text,
        "adminCode": codeController.text,
      });
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      print('Exception in adminLogin: $e');
      return 'Login failed: $e';
      //return 'Login failed: ${e.toString()}';
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
                          "images/admin.jpeg",
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        const SizedBox(height: 5.0),
                        const Text(
                          "Welcome Back\n you've been missed",
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
                            "Login:",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
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
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                            labelText: "Password",
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: codeController,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "Stokvel Code",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                            labelText: "Stokvel Code",
                            labelStyle: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            prefixIcon:
                                const Icon(Icons.code, color: Colors.black),
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
                              return "Please enter stokvel code";
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const AdminCodeResetScreen();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Reset Code!",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const AdminPasswordResetScreen();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
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
                                loginResult = adminLogin();
                                loginResult?.then((result) async {
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
                                                "The username, password and \ncode match was not found",
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
                                                codeController.clear();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    storeUsername(usernameController.text);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const UserStatementScreen();
                                        },
                                      ),
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
                            child: const Text("LOGIN"),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(width: .2),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminSignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register...",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "I'm not the Admin",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
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
/*
class AdminSecurityQuestions extends StatefulWidget {
  const AdminSecurityQuestions({super.key});

  @override
  AdminSecurityQuestionsState createState() => AdminSecurityQuestionsState();
}

class AdminSecurityQuestionsState extends State<AdminSecurityQuestions> {
  final _formKey = GlobalKey<FormState>();
  final List<String> questions = [
    'What was your childhood nickname?',
    'What is the name of the first primary school you attended?',
    'In what city did you meet your spouse/significant other?',
    'What is the name of your favorite childhood friend?',
    'What is the name of the city where your parents met?',
    'What is the name of your first girlfriend/boyfriend?',
    'What is your guilty pleasure?',
    'How many lips have you kissed?',
  ];
  String? selectedQuestion;
  String? answer;

  int currentQuestionIndex = 0;

  /* Database? db;

  Future<void> initDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'Stokvel.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Security-Questions(id INTEGER PRIMARY KEY, question TEXT, answer TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> saveSecurityQuestion() async {
    await db?.insert(
      'questions',
      {'question': selectedQuestion, 'answer': answer},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  void initState() {
    super.initState();
    initDb();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Security Questions'),
        backgroundColor: Colors.transparent,
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
                children: <Widget>[
                  Image.asset(
                    "images/icon.png",
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Security Questions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            "These questions will be asked prior to reset password or change account information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Flexible(
                    child: DropdownButtonFormField<String>(
                      value: selectedQuestion,
                      items: questions.map((String question) {
                        return DropdownMenuItem<String>(
                          value: question,
                          child: Text(
                            question,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onTap: () async {
                        final selectedQuestion = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text('Select question'),
                              children: questions.map((String question) {
                                return SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, question);
                                  },
                                  child: Text(
                                    question,
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        );

                        if (selectedQuestion != null) {
                          setState(() {
                            this.selectedQuestion = selectedQuestion;
                          });
                        }
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedQuestion = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a question';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Question',
                        hintText: "Choose a question",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.question_answer, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      answer = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your answer';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Answer',
                      hintText: "Enter your answer",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                      prefixIcon:
                          Icon(Icons.question_answer, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: 400.0,
                    height: 40,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //await saveSecurityQuestion();
                          if (currentQuestionIndex < 2) {
                            setState(() {
                              currentQuestionIndex++;
                              selectedQuestion = null;
                              answer = null;
                            });
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const AdminRegistrationForm();
                                },
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: Text(currentQuestionIndex < 2 ? 'Next' : 'Finish'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/