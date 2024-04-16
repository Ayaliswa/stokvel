import 'dart:convert';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:stokvel/stokvel_info.dart";

class AddMembersScreen extends StatefulWidget {
  const AddMembersScreen({super.key});

  @override
  State<AddMembersScreen> createState() => AddMembersScreenState();
}

class AddMembersScreenState extends State<AddMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<String> addStokvelMember() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/addStokvelMember.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "phone": phoneController.text,
      });
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      print('Exception in addMember: $e');
      return 'Failed to add member: $e';
      //return 'Password reset authentication failed: ${e.toString()}';
    }
  }

  String validatePhoneNumber(String phoneNumber) {
    final RegExp phoneRegExp = RegExp(r'^[7689]\d{7}$');
    if (!phoneRegExp.hasMatch(phoneNumber)) {
      if (phoneNumber.length < 8) {
        return 'Phone number is too short';
      } else {
        return 'Phone number is too long or invalid format\nshould start with 7 (6/8/9) and not more than 8';
      }
    }
    return 'Valid';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("Add Stokvel Member"),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/icon.png",
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add Member to \nCity United Stokvel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: "+268 7......",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16),
                          labelText: "Phone",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          prefixIcon: Icon(Icons.phone, color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter phone number";
                          }

                          final String validationResult =
                              validatePhoneNumber(value);
                          if (validationResult != 'Valid') {
                            return validationResult;
                          }
                          return null;
                        },
                        maxLength: 8,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: 400.0,
                        height: 40,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              var addResult = addStokvelMember();
                              addResult.then((result) async {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (result != 'Success') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Row(
                                          children: [
                                            Icon(Icons.close,
                                                color: Colors.red),
                                            Text(
                                              "Error",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          "Failed to add member",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Try again"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              phoneController.clear();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text("Member Added"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Add More"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              phoneController.clear();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: const Text("ADD MEMBER"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const StokvelInfo();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "RETURN BACK",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
      ],
    );
  }
}
