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
  String description = "Monthly Contribution";
  String description2 = "Loan Repayment";
  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountReceiverController =
      TextEditingController();
  Future<String>? phoneNumber;
  Future<String>? firstName;
  Future<String>? lastName;
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

  Future<String?> getNameByPhone() async {
    try {
      String? phone = await getPhoneByUsername();
      print("name 1");
      String url =
          "http://127.0.0.1/stokvel_api/getNameByPhone.php?phone=$phone";
      print("name 2");
      Map<String, String?> body = {"phone": phone};
      dynamic response = await http.post(Uri.parse(url), body: body);

      print(response.body);
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
        throw Exception('Failed to fetch name: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> getSurnameByPhone() async {
    try {
      String? phone = await getPhoneByUsername();
      String url =
          "http://127.0.0.1/stokvel_api/getSurnameByPhone.php?phone=$phone";
      Map<String, String?> body = {"phone": phone};
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
        throw Exception('Failed to fetch name: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String> getMemberTotalContributions() async {
    try {
      String? phoneNumber = await getPhoneByUsername();
      String url =
          "http://127.0.0.1/stokvel_api/getMemberTotalContributions.php?phoneNumber=$phoneNumber";

      Map<String, String?> body = {
        "description": description,
        "description2": description2,
        "phoneNumber": phoneNumber
      };
      dynamic response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        var totalAmount = json.decode(response.body);
        return totalAmount;
      } else {
        throw Exception('Failed to fetch transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch stokvel available balance: $e');
    }
  }

  Future<String> saveStokvelRequest() async {
    try {
      String? phoneNumber = await getPhoneByUsername();
      String? firstName = await getNameByPhone();
      print("6");
      String? lastName = await getSurnameByPhone();
      String url = "http://127.0.0.1/stokvel_api/saveStokvelRequest.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "phone": phoneNumber,
        "name": firstName,
        "surname": lastName,
        "amount": amountController.text,
        "receiver": accountReceiverController.text,
        "timestamp": DateTime.now().toIso8601String(),
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data == "Error") {
          return 'Error';
        } else {
          return 'Success';
        }
      } else {
        return 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
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
      body: Column(
        children: [
          const UserHeader(),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "How much do you want to request from the stokvel "
            "and which phone number to receive request once approved",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: amountController,
                              decoration: const InputDecoration(
                                hintText: "enter request amount",
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
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
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
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
                                      side:
                                          const BorderSide(color: Colors.green),
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
                                      side: const BorderSide(color: Colors.red),
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
            ),
          ),
        ],
      ),
    );
  }
}
