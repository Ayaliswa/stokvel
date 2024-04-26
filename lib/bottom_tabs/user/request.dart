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
  String description3 = "Loan Requested";
  bool _isLoading = false;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountReceiverController =
      TextEditingController();
  Future<String>? validateRequest;
  Future<String>? sendRequest;
  Future<String>? phoneNumber;
  Future<String>? firstName;
  Future<String>? lastName;
  int selectedItem = 2;

  @override
  void initState() {
    super.initState();
    calculateAndFormatAmount();
  }

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

  calculateInterest() {
    String amountString = amountController.text;

    if (amountString.isEmpty) {
      return "0.00";
    }

    double amount = double.parse(amountString);
    double interest = amount * 0.2;

    String formattedInterest = interest.toStringAsFixed(2);

    return formattedInterest;
  }

  addInterest() {
    String amountString = amountController.text;
    String interestOnAmount = calculateInterest();

    if (amountString.isEmpty) {
      return "0.00";
    }

    double interest = double.parse(interestOnAmount);
    double amount = double.parse(amountString);
    double finalAmount = amount + interest;

    String formattedAmount = finalAmount.toStringAsFixed(2);

    return formattedAmount;
  }

  showInterestDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text(
                "Request Interest Calculation",
                style: TextStyle(color: Colors.green),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 1),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "INTEREST FOR E ${amountController.text}.00 = ",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 2,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "E ${calculateInterest()}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "RETURN AMOUNT = ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "E ${addInterest()}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
      String url =
          "http://127.0.0.1/stokvel_api/getNameByPhone.php?phone=$phone";
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

  Future<String>? validateRequestLimit() async {
    try {
      String? phoneNumber = await getPhoneByUsername();
      String url =
          "http://127.0.0.1/stokvel_api/validateRequestLimit.php?phoneNumber=$phoneNumber";

      dynamic response = await http.post(Uri.parse(url), body: {
        "description": description,
        "description2": description2,
        "description3": description3,
        "phoneNumber": phoneNumber,
        "requestAmount": amountController.text,
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

  Future<String> calculateAndFormatAmount() async {
    double amountAsDouble = double.parse(addInterest());
    int amountAsInteger = amountAsDouble.truncate();
    String amountAsString = amountAsInteger.toString();
    return amountAsString;
  }

  Future<String> saveStokvelRequest() async {
    try {
      String? phoneNumber = await getPhoneByUsername();
      String? firstName = await getNameByPhone();
      String? lastName = await getSurnameByPhone();
      String? amount = await calculateAndFormatAmount();

      String url = "http://127.0.0.1/stokvel_api/saveStokvelRequest.php";

      dynamic response = await http.post(Uri.parse(url), body: {
        "phone": phoneNumber,
        "name": firstName,
        "surname": lastName,
        "amount": amountController.text,
        "repay": amount,
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
    return Stack(children: [
      Scaffold(
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
            const SizedBox(
              height: 10,
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
                                height: 5,
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
                              ElevatedButton(
                                onPressed: () {
                                  if (amountController.text != "") {
                                    calculateInterest();
                                    addInterest();
                                    showInterestDetails();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "No amount found",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: const Row(
                                            children: [
                                              Icon(Icons.error_outline,
                                                  color: Colors.red),
                                              Text(
                                                "Please enter amount to calculate intrest from",
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("Try again"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                amountController.clear();
                                                accountReceiverController
                                                    .clear();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(40, 40),
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  side:
                                      const BorderSide(color: Colors.blueGrey),
                                ),
                                child: const Text(
                                  'CALCULATE INTEREST %\nOn Request',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          validateRequest =
                                              validateRequestLimit();
                                          validateRequest?.then((result) async {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            if (result != "Success") {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Error",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    content: const Row(
                                                      children: [
                                                        Icon(
                                                            Icons.error_outline,
                                                            color: Colors.red),
                                                        Text(
                                                          "Request amount exceed your contributed amount\nrequest less or equal to your contribution",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text(
                                                            "Try again"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          amountController
                                                              .clear();
                                                          accountReceiverController
                                                              .clear();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              sendRequest =
                                                  saveStokvelRequest();
                                              sendRequest?.then((result) async {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                if (result != 'Success') {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Error",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        content: const Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .error_outline,
                                                                color:
                                                                    Colors.red),
                                                            Text(
                                                              "Request could not be sent",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                "Try again"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              amountController
                                                                  .clear();
                                                              accountReceiverController
                                                                  .clear();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Success",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        content: const Row(
                                                          children: [
                                                            Icon(Icons.check,
                                                                color: Colors
                                                                    .black),
                                                            Text(
                                                              "Request successfully sent",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                "OK"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return const UserStatementScreen();
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              });
                                            }
                                          });
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
                                        amountController.clear();
                                        accountReceiverController.clear();
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
              ),
            ),
          ],
        ),
      ),
      if (_isLoading)
        Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
    ]);
  }
}
