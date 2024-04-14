import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/bottom_navigation_bar/user_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/user/request.dart';
import 'package:stokvel/bottom_tabs/user/statement.dart';
import 'package:stokvel/header/user.dart';

class UserTransactionScreen extends StatefulWidget {
  const UserTransactionScreen({super.key});

  @override
  State<UserTransactionScreen> createState() => UserTransactionScreenState();
}

class UserTransactionScreenState extends State<UserTransactionScreen> {
  int selectedItem = 1;
  int selectedPaymentMethod = 0;
  String? dropdownValue;
  String? selectedMessage;
  final currencyCode = 'SZL';
  final _formKey = GlobalKey<FormState>();
  Future<String>? phoneNumber;
  final amountController = TextEditingController();
  final phoneNumberController = TextEditingController();

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
    if (index == 1) {}
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserRequestScreen()),
      );
    }
  }
/*
  Future<http.Response> initiateTransfer(
      String recipientPhone, double amount) async {
    print("initiateTransfer called");
    String url = "http://127.0.0.1/stokvel_api/initiateMoMoTransfer.php";
    dynamic response = await http.post(Uri.parse(url), body: {
      'recipientPhone': recipientPhone,
      'amount': amount.toString(),
    });
    print("two");

    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        print('Transfer request initiated successfully!');
      } else {
        print('Error initiating transfer: ${data['message']}');
      }
    } else {
      print('Error sending request: ${response.statusCode}');
    }
    return response;
  }
*/

  Future<String> saveStokvelTransaction() async {
    print('saveStokvelTransaction fuction called');
    try {
      String? username = await getUsername();
      String? phoneNumber = await getPhoneByUsername();
      String url = "http://127.0.0.1/stokvel_api/saveStokvelTransaction.php";
      print('save one');
      dynamic response = await http.post(Uri.parse(url), body: {
        "memberPhone": phoneNumber,
        "depositer": username,
        "amount": amountController.text,
        "description": selectedMessage,
        "source": phoneNumberController.text,
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

  /* Future<http.Response> requestToPay(
      String phoneNumberController, double amountController) async {
    final url = Uri.parse('https:// momo.developer.mtn.com/v1_0/requesttopay');
    final body = jsonEncode({
      'amount': amountController.toString(), // Convert amount to string
      'payerPrimaryAccountNumber': '26876416393',
      'payerReference':
          '${DateTime.now().millisecondsSinceEpoch}-$phoneNumberController', // Example reference
      'payeePrimaryAccountNumber': "268$phoneNumberController",
      'currency': currencyCode, // Replace with your currency code
    });

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Ocp-Apim-Subscription-Key':
          '54b7ffd6a2d2443d8bcb542c943f0c0f',
      'X-Reference-Id':
          '${DateTime.now().millisecondsSinceEpoch}',
    };

    final response = await http.post(url, headers: headers, body: body);
    return response;
  }*/
/*
  Future<String> payment() async {
    try {
      String urlString = "http://192.168.56.1/stokvel_api/momo.php";
      Uri url = Uri.parse(urlString);
      var response = await http.post(url, body: {
        "Amount": amountController.text,
        "AccountNumber": phoneNumberController.text,
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const UserStatementScreen();
            },
          ),
        );
        return "Success";
      }
    } catch (e) {
      print('Exception in handleLogin: ${e.toString()}');
      return 'Login failed: ${e.toString()}';
    }
  }
*/

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Future<String?> getPhoneByUsername() async {
    try {
      String username = await getUsername();
      print(username);
      print('get one');
      String url =
          "http://127.0.0.1/stokvel_api/getPhoneByUsername.php?username=$username";
      print('get two');
      Map<String, String> body = {"username": username};
      dynamic response = await http.post(Uri.parse(url), body: body);
      print('get three');

      print('get four');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        print(response.body);
        print('get five');
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            return data; // Return the phone number as a string
          } else {
            print('Empty phone number received');
            return null;
          }
        } else {
          // ... handle other status codes
        }
      } else {
        print('Error fetching phone: ${response.statusCode}');
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in getPhoneByUsername: $e');
      rethrow;
    }
    return null;
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
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      child: SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Available Stokvel Accounts",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 0;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "images/MoMo.jpeg"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 1;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "images/eMali.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 2;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image:
                                                  AssetImage("images/Visa.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (selectedPaymentMethod == 0)
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            const Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.start,
                                                  "Deposit via MoMo account",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              controller: amountController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'How much do you want to deposit',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                                labelText: 'Amount',
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                                prefixIcon: Icon(
                                                    Icons.monetization_on,
                                                    color: Colors.black),
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter amount';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            InputDecorator(
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isDense: true,
                                                  value: selectedMessage,
                                                  hint: const Text(
                                                      'Select payment type'),
                                                  items: <String>[
                                                    'Monthly Contribution',
                                                    'Loan Repayment'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 25),
                                                        child: Text(value),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    selectedMessage = newValue;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please select a payment type';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: phoneNumberController,
                                              decoration: const InputDecoration(
                                                hintText: '76******',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                                labelText: 'Phone Number',
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                                prefixIcon: Icon(Icons.phone,
                                                    color: Colors.black),
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please enter phone number";
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 35,
                                            ),
                                            Center(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        saveStokvelTransaction();
                                                        /*var recipientPhone =
                                                            phoneNumberController
                                                                .text;
                                                        var amount =
                                                            double.parse(
                                                                amountController
                                                                    .text);*/

                                                        /*await initiateTransfer(
                                                            recipientPhone,
                                                            amount);*/

                                                        //saveTransaction();

                                                        /*final phoneNumber =
                                                            phoneNumberController
                                                                .text;

                                                        // Replace with your actual MoMo API credentials (store securely)
                                                        const apiKey =
                                                            'YOUR_API_KEY';
                                                        const baseUrl =
                                                            'https://sandbox.momodeveloper.mtn.com';

                                                        // Currency code (replace with your supported currency)
                                                        const currencyCode =
                                                            'ZAR';

                                                        // Amount (convert to a number before sending)
                                                        final double amount =
                                                            double.tryParse(
                                                                    amountController
                                                                        .text) ??
                                                                0.0;

                                                        final url = Uri.parse(
                                                            '$baseUrl/collection/v1_0/requesttopay');

                                                        final response =
                                                            await http.post(
                                                          url,
                                                          headers: {
                                                            'Content-Type':
                                                                'application/json; charset=UTF-8',
                                                            'Authorization':
                                                                'Bearer $apiKey', // Assuming API key authentication
                                                            'Cache-Control':
                                                                'no-cache',
                                                          },
                                                          body: jsonEncode({
                                                            'payer': {
                                                              'partyIdType':
                                                                  'MSISDN',
                                                              'partyId':
                                                                  phoneNumber,
                                                            },
                                                            'payerCurrency':
                                                                currencyCode,
                                                            'payerMessage':
                                                                'Payment for your order', // Optional message
                                                            'amount': amount,
                                                            'validityTime':
                                                                300, // 5 minutes in seconds
                                                          }),
                                                        );

                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          final data =
                                                              jsonDecode(
                                                                  response
                                                                      .body);
                                                          if (data['status'] ==
                                                              'CREATED') {
                                                            // Assuming successful creation key
                                                            print(
                                                                'Payment preapproval created successfully.');
                                                            // Handle successful preapproval (e.g., show confirmation to user)
                                                          } else {
                                                            print(
                                                                'Error creating preapproval: ${data['errorMessage']}');
                                                            // Handle specific errors from MoMo API (show user-friendly message)
                                                          }
                                                        } else {
                                                          print(
                                                              'Error requesting payment: ${response.statusCode}');
                                                          // Handle general errors (show user-friendly message)
                                                        }*/
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      foregroundColor:
                                                          Colors.white,
                                                      side: const BorderSide(
                                                          color: Colors.green),
                                                    ),
                                                    child:
                                                        const Text('APPROVE'),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _formKey.currentState!
                                                          .reset();
                                                      /*amountController.clear();
                                                      selectedMessage == '';
                                                      phoneNumberController
                                                          .clear();*/
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      side: const BorderSide(
                                                          color: Colors.red),
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
                                  )
                                else if (selectedPaymentMethod == 1)
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.start,
                                                "Deposit via eMali account",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "How much do you want to deposit",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Amount",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter amount";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 3),
                                              border: OutlineInputBorder(),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                isDense: true,
                                                value: selectedMessage,
                                                hint: const Text(
                                                    'Select payment type'),
                                                items: <String>[
                                                  'Monthly contribution',
                                                  'Loan repayment'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 25),
                                                      child: Text(value),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  selectedMessage = newValue;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please select a payment type';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: "79******",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Phone Number",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(Icons.phone,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter phone number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.green),
                                                  ),
                                                  child: const Text('APPROVE'),
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _formKey.currentState!
                                                        .reset();
                                                    /*amountController.clear();
                                                    selectedMessage == '';
                                                    phoneNumberController
                                                        .clear();*/
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  child: const Text('CANCEL'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else if (selectedPaymentMethod == 2)
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.start,
                                                "Deposit via Credit Card",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Enter amount to deposit",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Amount",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter amount you want to deposit";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 3),
                                              border: OutlineInputBorder(),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                isDense: true,
                                                value: selectedMessage,
                                                hint: const Text(
                                                    'Select payment type'),
                                                items: <String>[
                                                  'Monthly contribution',
                                                  'Loan repayment'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 25),
                                                      child: Text(value),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  selectedMessage = newValue;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please select a payment type';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Enter card registered name",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Card Holder Name",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(Icons.person,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter your name";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: "Enter Card Number",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Card Number",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(Icons.numbers,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Card number cannot be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text("Card Expiry Date",
                                              textAlign: TextAlign.start),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 20),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: DropdownButton<String>(
                                                    value: dropdownValue,
                                                    hint: const Text('Month'),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue;
                                                      });
                                                    },
                                                    items: <String>[
                                                      '01',
                                                      '02',
                                                      '03',
                                                      '04',
                                                      "05",
                                                      "06",
                                                      "07",
                                                      "08",
                                                      "09",
                                                      "10",
                                                      "11",
                                                      "12"
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Expanded(
                                                  child: DropdownButton<String>(
                                                    value: dropdownValue,
                                                    hint: const Text("Year"),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue;
                                                      });
                                                    },
                                                    items: <String>[
                                                      "2024",
                                                      "2025",
                                                      "2026",
                                                      "2027",
                                                      "2028",
                                                      "2029",
                                                      "2030",
                                                      "2031",
                                                      "2032",
                                                      "2033",
                                                      "2034",
                                                      "2035",
                                                      "2036",
                                                      "2037",
                                                      "2038",
                                                      "2039",
                                                      "2040",
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                if (dropdownValue != null)
                                                  Text(
                                                      'Selected: $dropdownValue'),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.name,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "3 digits next to card number",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16),
                                                    labelText:
                                                        "Card CVV Number",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
                                                    prefixIcon: Icon(
                                                        Icons.numbers,
                                                        color: Colors.black),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter your Card CVV Number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons
                                                    .question_mark_rounded),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.green),
                                                  ),
                                                  child: const Text('NEXT...'),
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _formKey.currentState!
                                                        .reset();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  child: const Text('CANCEL'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
