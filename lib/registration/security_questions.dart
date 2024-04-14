//import 'dart:convert';

import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

//import 'registration_screen.dart';

class SecurityQuestions extends StatefulWidget {
  final String phoneNumber;
  const SecurityQuestions({super.key, required this.phoneNumber});

  @override
  SecurityQuestionsState createState() => SecurityQuestionsState();
}

class SecurityQuestionsState extends State<SecurityQuestions> {
  final _formKey = GlobalKey<FormState>();
  final List<String> questions = [
    'What was your childhood nickname?',
    'What is the name of the first primary school you attended?',
    'In what city did you meet your spouse/significant other?',
    'What is the name of your favorite childhood friend?',
    'What is the name of the city where your parents met?',
    'What is the name of your first girlfriend/boyfriend?',
    'What is your guilty pleasure?',
    'How many lips have you kissed?',
  ];

  List<Map<String, String>> questionAnswerPairs = [];
  String? selectedQuestion;
  String? answer;

  int currentQuestionIndex = 0;

  Future saveSecurityQuestion() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/stokvel_api/save_security_question.php'),
      body: json.encode(<String, String>{
        'phone': widget.phoneNumber,
        'questionAnswerPairs': json.encode(questionAnswerPairs),
        //'question': selectedQuestion!,
        //'answer': answer!,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      print('Question and answer saved successfully');
    } else {
      // If the server returns an unexpected response, then throw an exception.
      throw Exception('Failed to save question and answer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.blue,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "images/icon.png",
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Security Questions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "These questions will be asked prior to reset password or change account information",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  DropdownButtonFormField<String>(
                    value: selectedQuestion,
                    selectedItemBuilder: (BuildContext context) {
                      return questions.map<Widget>((String question) {
                        return Container(
                          width: 320,
                          child: Text(
                            question,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList();
                    },
                    items: questions.map((String question) {
                      return DropdownMenuItem<String>(
                        value: question,
                        child: Container(
                          width: 320,
                          child: Text(
                            question,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedQuestion = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a question';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Question',
                      hintText: "Choose a question",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                      prefixIcon:
                          Icon(Icons.question_mark, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: TextFormField(
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
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          prefixIcon:
                              Icon(Icons.draw_rounded, color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20.0),
                  Container(
                    width: 400.0,
                    height: 40,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          questionAnswerPairs.add({
                            'question': selectedQuestion!,
                            'answer': answer!,
                          });
                          //await saveSecurityQuestion();
                          if (currentQuestionIndex < 2) {
                            setState(() {
                              currentQuestionIndex++;
                              selectedQuestion = null;
                              answer = null;
                            });
                          } else {
                            await saveSecurityQuestion();
                            /*Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const RegistrationForm();
                                },
                              ),
                            );*/
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: Text(currentQuestionIndex < 2 ? 'Next' : 'Finish'),
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
