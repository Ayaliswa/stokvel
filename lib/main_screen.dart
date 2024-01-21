import "package:flutter/material.dart";
import "login_screen.dart";
import "sign_up_screen.dart";

void main() => runApp(const Stokvel());

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
          const MainWelcomePage(),
        ],
      ),
    );
  }
}

class MainWelcomePage extends StatelessWidget {
  const MainWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Hello, Welcome to City United Stokvel",
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
              "Press the login button to continue to stokvel else register and get started",
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
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/icon.png"),
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Navigator(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => HomeScreen());
            case '/login':
              return MaterialPageRoute(builder: (context) => LoginScreen());
            default:
              return null;
          }
        },
      ),
    );
  }
}
 */
