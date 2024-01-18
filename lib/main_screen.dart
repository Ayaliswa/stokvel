import "package:flutter/material.dart";
import "login_screen.dart";
import "sign_up_screen.dart";

void main() => runApp(const Stokvel());

class Stokvel extends StatelessWidget {
  const Stokvel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stokvel Main Screen",
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgroung3.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to City United Stokvel",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.blue,
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
              const SizedBox(height: 16),
              const Text(
                "Please press the login button to continue else register and get started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              // const Spacer(),
              const SizedBox(height: 20.0),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icon.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                width: 400.0,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text("LOGIN"),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200.0,
                height: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const SizedBox(height: 8),
              Container(
                width: 400.0,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to sign up screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text("REGISTER"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
