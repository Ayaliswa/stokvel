import "package:flutter/material.dart";
import "recovery_questions_screen.dart";

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sign Up Screen",
      home: Stack(
        children: <Widget>[
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
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(
                    context), // Handle back to previous page navigation
              ),
              title: const Text("Stokvel"),
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/icon.png",
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "create username",
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "+268 76------",
                      labelText: "Phone",
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "create password",
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "confirm your password",
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(width: 20),
                      Radio(value: null, groupValue: null, onChanged: null),
                      Text("Male"),
                      SizedBox(width: 20),
                      Radio(value: null, groupValue: null, onChanged: null),
                      Text("Female"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Checkbox(value: false, onChanged: null),
                      const Text("Accept"),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          // navigate to terms of use
                        },
                        child: const Text(
                          "Terms of Use",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Register"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          // Navigate to login screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RecoveryQuestionsScreen()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
