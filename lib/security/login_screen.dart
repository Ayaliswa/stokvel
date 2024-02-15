import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:stokvel/bottom_tabs/user/statement.dart';
import '../registration/sign_up_screen.dart';
import 'password_reset_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Future<String>? loginResult;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String> handleLogin() async {
    final usernameOrPhone = usernameController.text;
    final password = passwordController.text;

    BuildContext currentContext = context;

    final loginCollection = FirebaseFirestore.instance.collection('Login');
    final querySnapshotByUsername = await loginCollection
        .where('Username', isEqualTo: usernameOrPhone)
        .get();
    final querySnapshotByPhone =
        await loginCollection.where('Phone', isEqualTo: usernameOrPhone).get();

    if (querySnapshotByUsername.docs.isEmpty &&
        querySnapshotByPhone.docs.isEmpty) {
      return 'No user found with that username or phone number.';
    }

    final user = querySnapshotByUsername.docs.isNotEmpty
        ? querySnapshotByUsername.docs.first
        : querySnapshotByPhone.docs.first;
    if (user['Password'] != password) {
      return 'Incorrect password.';
    } else {
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      Navigator.of(currentContext).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const UserStatementScreen();
          },
        ),
      );
      return 'Success';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Screen",
      home: Scaffold(
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
                      "images/loginphoto.png",
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
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
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
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: "Password",
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const PasswordResetScreen();
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
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text("\t\tLoading..."),
                                    ],
                                  ),
                                );
                              },
                            );
                            loginResult = handleLogin();
                            loginResult?.then((result) async {
                              Navigator.of(context).pop(); // Close the dialog
                              if (result != 'Success') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Error"),
                                      content: Text(result),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
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
                                      title: const Text("Login Successful"),
                                      content: const Text(
                                          "Welcome back to \nCity United Stokvel"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return const UserStatementScreen();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                await Future.delayed(
                                    const Duration(seconds: 3));
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
                    FutureBuilder<String>(
                      future: loginResult,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          if (snapshot.data ==
                              'Welcome Back to \nCity United Stokvel') {
                            return Container();
                          } else {
                            return Text(snapshot.data!);
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        const SizedBox(width: .2),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
                            "Register...",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
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
    );
  }
}
