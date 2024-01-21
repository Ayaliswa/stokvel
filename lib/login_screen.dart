import "package:flutter/material.dart";
import "sign_up_screen.dart";
import "password_reset_screen.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Screen",
      home: Stack(
        children: <Widget>[
          Image.asset(
            "images/background4.png",
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
          const Login(),
        ],
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context), // Handle back to previous page navigation
        ),
        title: const Text("Stokvel"),
        backgroundColor: Colors.blue,
      ),
      //backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Enter Username or Phone",
                  labelText: "Username",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to login screen
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
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const LoginScreen();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text("LOGIN"),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
