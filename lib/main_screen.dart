import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:stokvel/firebase_options.dart";
import "login_screen.dart";
import "sign_up_screen.dart";

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Stokvel());
}

class Stokvel extends StatelessWidget {
  const Stokvel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Stokvel Main Screen",
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
          const MainWelcomeScreen(),
        ],
      ),
    );
  }
}

class MainWelcomeScreen extends StatelessWidget {
  const MainWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SizedBox(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10.0),
                const Text(
                  "Hello,",
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.black,
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
                const Center(
                  child: Text(
                    "Welcome to City United Stokvel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
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
                ),
                const Spacer(),
                const Text(
                  "Press the login button to continue to stokvel else register and get started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: 400.0,
                  height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                const SizedBox(height: 16),
                Container(
                  width: 400.0,
                  height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text("REGISTER"),
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
