import "package:flutter/material.dart";
import "login_screen.dart";

class RecoveryQuestionsScreen extends StatefulWidget {
  const RecoveryQuestionsScreen({super.key});

  @override
  _RecoveryQuestionsScreenState createState() =>
      _RecoveryQuestionsScreenState();
}

class _RecoveryQuestionsScreenState extends State<RecoveryQuestionsScreen> {
  final List<String> _questions = [
    'What is your favorite color?',
    'What is your mother\'s maiden name?',
    'What is your first girlfriend/boyfriend surname?',
    'What is the name of your first pet?',
    'What is your favorite food?',
    'What is your favorite movie?',
    'What is your favorite book?',
    'What is your favorite song?',
  ];

  int _currentQuestionIndex = 0;
  final List<String> _selectedQuestions = List.filled(3, '');
  final List<TextEditingController> _answerControllers =
      List.generate(3, (_) => TextEditingController());

  void _nextQuestion() {
    if (_currentQuestionIndex < 2) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Navigate to login screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recovery Question Screen",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Recovery Question'),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16.0),
                        const Text(
                          'Choose three questions below and answer in the space provided below, after each question press next to answer next question.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Question ${_currentQuestionIndex + 1}',
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _selectedQuestions[_currentQuestionIndex],
                          items: _questions
                              .map((question) => DropdownMenuItem(
                                    value: question,
                                    child: Text(question),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedQuestions[_currentQuestionIndex] =
                                  "value";
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Question',
                            hintText: 'Choose a question here',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _answerControllers[_currentQuestionIndex],
                          decoration: const InputDecoration(
                            labelText: 'Answer',
                            hintText: 'Enter your answer here',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _nextQuestion,
                          child: Text(
                              _currentQuestionIndex < 2 ? 'Next' : 'Finish'),
                        ),
                      ],
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
