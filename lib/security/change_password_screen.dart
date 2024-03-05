import "package:flutter/material.dart";
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureText = true;

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
        title: const Text("Change Password"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Create New Password",
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
                Image.asset(
                  "images/icon.png",
                  height: MediaQuery.of(context).size.height / 3,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Update to new password",
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
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "enter current password",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    labelText: "Password",
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 18),
                    prefixIcon: const Icon(Icons.key, color: Colors.black),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "create your new password",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    labelText: "New Password",
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 18),
                    prefixIcon: const Icon(Icons.key, color: Colors.black),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "corfirm your password",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    labelText: "Confirm New Password",
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 18),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text("FINISH"),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
