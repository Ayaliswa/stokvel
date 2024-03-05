import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'login_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  PasswordResetScreenState createState() => PasswordResetScreenState();
}

class PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> questions = [];
  String? answer;
  int currentQuestionIndex = 0;
  int correctAnswers = 0;

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'stokvel.db'),
    );

    final List<Map<String, dynamic>> questionsCollection =
        await database.query('questions');

    return questionsCollection;
  }

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> checkSecurityQuestion() async {
    if (questions[currentQuestionIndex]['answer'] == answer) {
      correctAnswers++;
      if (correctAnswers < 3) {
        setState(() {
          currentQuestionIndex++;
          answer = null;
        });
      } else {
        Navigator.of(context as BuildContext).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const ChangePassword();
            },
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(
            content: Text(
                'Incorrect answer. \nMake sure your answer matches exact the one you provided when creating your account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  questions.isNotEmpty
                      ? questions[currentQuestionIndex]['question']
                      : '',
                  style: const TextStyle(fontSize: 18),
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
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await checkSecurityQuestion();
                    }
                  },
                  child: Text(correctAnswers < 2 ? 'Next' : 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  

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
        title: const Text("Forgot Password?"),
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
                  "Reset Password",
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
                  alignment: Alignment.center,
                  child: Text(
                    "For confirmation that it is you, the account owner, please enter your recovery phone number below and through it you will receive the OTP to continue reset your password",
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
                            return const PasswordResetCode();
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

class PasswordResetCode extends StatelessWidget {
  const PasswordResetCode({super.key});

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
        title: const Text("Forgot Password?"),
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
                  "Reset Password",
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
                    "Now please enter the OTP sent to your recovery phone number",
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
                    hintText: "enter OTP sent to your recovery phone",
                    labelText: "OTP",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    prefixIcon: Icon(Icons.numbers, color: Colors.black),
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
                            return const ChangePassword();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text("CONTINUE"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't recieve OTP?",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(width: .2),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "resend OTP...",
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
    );
  }
}
*/
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
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
                    "Almost Done!! Now create your new password",
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
                    labelText: "Confirm Password",
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
