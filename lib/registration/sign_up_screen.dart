import "package:flutter/material.dart";
import 'registration_screen.dart';
import '../security/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText = true;
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sign Up Screen",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Stokvel"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Let's create an account for you",
                    textAlign: TextAlign.center,
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sign up:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "create username",
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
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "+268 7......",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      labelText: "Phone",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter phone number";
                      }
                      return null;
                    },
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "example@gmail.com",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                      prefixIcon: Icon(Icons.mail, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter email address";
                      }
                      return null;
                    },
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: _obscureText,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "create password",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 16),
                      labelText: "Password",
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 18),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: _obscureText,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "confirm your password",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 16),
                      labelText: "Confirm Password",
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
                      Object password = "";
                      if (value!.isEmpty || value != password) {
                        return "Password do not match";
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
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: false,
                        groupValue: true,
                        onChanged: (value) => true,
                      ),
                      const Text("Male"),
                      const SizedBox(width: 20),
                      Radio(
                        value: false,
                        groupValue: true,
                        onChanged: (value) => true,
                      ),
                      const Text("Female"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) => true,
                      ),
                      const Text("Accept"),
                      const SizedBox(width: 0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddRecoveryPhone()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: const Text("CREATE ACCOUNT"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black, fontSize: 16),
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
    );
  }
}

class AddRecoveryPhone extends StatelessWidget {
  const AddRecoveryPhone({super.key});

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
        title: const Text("Stokvel"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Add Recovery Phone Number",
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
                    "enter recovery phone number that will be used to send password reset OTP in case you've forgotten your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "enter recovery phone number",
                    labelText: "Recovery Phone",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    prefixIcon: Icon(Icons.phone, color: Colors.black),
                    border: OutlineInputBorder(),
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
                            return const RegistrationForm();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text("NEXT"),
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