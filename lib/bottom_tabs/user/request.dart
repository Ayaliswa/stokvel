import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/bottom_navigation_bar/user_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/user/statement.dart';
import 'package:stokvel/bottom_tabs/user/transaction.dart';
import 'package:stokvel/header/user.dart';

class UserRequestScreen extends StatefulWidget {
  const UserRequestScreen({super.key});

  @override
  UserRequestScreenState createState() => UserRequestScreenState();
}

class UserRequestScreenState extends State<UserRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountReceiverController =
      TextEditingController();
  Future<String>? phoneNumber;
  int selectedItem = 2;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserStatementScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserTransactionScreen()),
      );
    }
    if (index == 2) {}
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Future<String?> getPhoneByUsername() async {
    try {
      String username = await getUsername();
      String url =
          "http://127.0.0.1/stokvel_api/getPhoneByUsername.php?username=$username";
      Map<String, String> body = {"username": username};
      dynamic response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            return data;
          } else {
            return null;
          }
        }
      } else {
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String> saveStokvelRequest() async {
    print('saveStokvelTransaction fuction called');
    try {
      String? phoneNumber = await getPhoneByUsername();
      String url = "http://127.0.0.1/stokvel_api/saveStokvelRequest.php";
      print('save one');
      dynamic response = await http.post(Uri.parse(url), body: {
        "phone": phoneNumber,
        "name": nameController.text,
        "surname": surnameController.text,
        "amount": amountController.text,
        "receiver": accountReceiverController.text,
        "timestamp": DateTime.now().toIso8601String(),
      });
      print('Two');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data == "Error") {
          return 'Error';
        } else {
          return 'Success';
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      print('Exception in saveStokvelTransaction: $e');
      return 'Failed to save transaction: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UserNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserHeader(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: SizedBox(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: "enter your first name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.black),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: surnameController,
                                decoration: const InputDecoration(
                                  hintText: "enter your surname",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  labelText: 'Surname',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.black),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your surname';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: amountController,
                                decoration: const InputDecoration(
                                  hintText: "enter request amount",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  labelText: 'Amount',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  prefixIcon:
                                      Icon(Icons.money, color: Colors.black),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an amount';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: accountReceiverController,
                                decoration: const InputDecoration(
                                  hintText: "enter beneficiary phone number",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  labelText: 'Account Receiver',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  prefixIcon:
                                      Icon(Icons.phone, color: Colors.black),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number to receive amount';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          saveStokvelRequest();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Colors.green),
                                      ),
                                      child: const Text('SUBMIT'),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _formKey.currentState!.reset();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        side:
                                            const BorderSide(color: Colors.red),
                                      ),
                                      child: const Text('CANCEL'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
