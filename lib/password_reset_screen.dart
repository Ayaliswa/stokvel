import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questions = [
    'What is your favorite color?',
    'What is your favorite food?',
    'What is your favorite animal?',
  ];
  final _answers = ['blue', 'pizza', 'dog'];
  int _currentQuestionIndex = 0;
  String _currentAnswer = '';
  bool _isAnswerCorrect = false;
  bool _isResetButtonEnabled = false;
  bool _isPasswordChanged = false;
  String _newPassword = '';
  String _confirmNewPassword = '';

  void _onAnswerSubmitted(String answer) {
    setState(() {
      _currentAnswer = answer;
      _isAnswerCorrect = _currentAnswer == _answers[_currentQuestionIndex];
      _isResetButtonEnabled = _isAnswerCorrect && _currentQuestionIndex == 2;
      if (_isAnswerCorrect && _currentQuestionIndex < 2) {
        _currentQuestionIndex++;
      }
    });
  }

  void _onResetButtonPressed() {
    setState(() {
      _isPasswordChanged = true;
    });
  }

  void _onChangePasswordButtonPressed() {
    setState(() {
      _isPasswordChanged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Reset Password'),
      ),
      body: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isPasswordChanged
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 16.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              hintText: 'Enter new password',
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _newPassword = value;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
                              hintText: 'Re-enter your new password',
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _confirmNewPassword = value;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_newPassword == _confirmNewPassword) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Success'),
                                    content:
                                        Text('Password changed successfully'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Passwords do not match'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text('Change Password'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please answer the following question:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _questions[_currentQuestionIndex],
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Answer',
                      ),
                      onChanged: _onAnswerSubmitted,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed:
                          _isResetButtonEnabled ? _onResetButtonPressed : null,
                      child: Text(
                          _isResetButtonEnabled ? 'Reset Password' : 'Next'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
