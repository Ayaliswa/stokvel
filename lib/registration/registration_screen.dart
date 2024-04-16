import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/security/login_screen.dart';

class RegistrationForm extends StatefulWidget {
  final String phoneNumber;
  const RegistrationForm({super.key, required this.phoneNumber});

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  Future<String>? phoneNumber;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final idController = TextEditingController();
  final postalAddressController = TextEditingController();
  final physicalAddressController = TextEditingController();
  Future<String>? regResult;
  bool _isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    idController.dispose();
    postalAddressController.dispose();
    physicalAddressController.dispose();
    super.dispose();
  }

  Future<String> register() async {
    print('register fuction called');
    try {
      String phoneNumber = await getPhone();
      String url = "http://127.0.0.1/stokvel_api/member_full_reg.php";
      print('One');
      dynamic response = await http.post(Uri.parse(url), body: {
        "phoneNumber": phoneNumber,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "id": idController.text,
        "postalAdd": postalAddressController.text,
        "physicalAdd": physicalAddressController.text,
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
      print('Exception in register: $e');
      return 'Failed to complete registration: $e';
    }
  }

  Future<String> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Stokvel Registration Screen",
      home: Stack(
        children: [
          Image.asset(
            "images/background3.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Center(
                child: Text('Failed to load image'),
              );
            },
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Registration'),
              backgroundColor: Colors.transparent,
            ),
            body: Center(
              child: SizedBox(
                width: 500,
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Stokvel Registration Form',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
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
                              'Register:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              labelText: 'First Name',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your surname',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              labelText: 'Last Name',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: idController,
                            decoration: const InputDecoration(
                              hintText: 'enter identity card number',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              labelText: 'ID Number',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'ID No. is required';
                              } else if (value.length != 13) {
                                return 'ID Number must be 13 digits';
                              } else if (!RegExp(r'^[0-9]{2}$')
                                  .hasMatch(value.substring(0, 2))) {
                                return 'First two digits must be between 01 and 99';
                              } else if (!RegExp(r'^0[1-9]|1[0-2]$')
                                  .hasMatch(value.substring(2, 4))) {
                                return 'Second two digits must be a month (01-12)';
                              } else if (!RegExp(r'^[0-2][1-9]|3[0-1]$')
                                  .hasMatch(value.substring(4, 6))) {
                                return 'Third two digits must be a day (01-31)';
                              } else if (!RegExp(r'^[67]1$')
                                  .hasMatch(value.substring(6, 8))) {
                                return 'Fourth two digits must be 61 or 71';
                              } else {
                                return null; // Valid ID number
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: postalAddressController,
                            decoration: const InputDecoration(
                              hintText: 'P O Box 1 CityName',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              labelText: 'Postal Address',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              prefixIcon: Icon(Icons.local_post_office,
                                  color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your postal address';
                              } /*else if (!RegExp(r'^P O Box [0-9]{1,3}$')
                                  .hasMatch(value)) {
                                return 'Invalid format: P.O. Box followed by a number (max 3 digits)';
                              }*/
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: physicalAddressController,
                            decoration: const InputDecoration(
                              hintText: 'where do you stay?',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              labelText: 'Residential Address',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              prefixIcon:
                                  Icon(Icons.location_on, color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your residential address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          /*const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Proof of Residence',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return Colors.white;
                                      }
                                      return Colors.black;
                                    },
                                  ),
                                ),
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    PlatformFile file = result.files.first;
                                    var request = http.MultipartRequest(
                                        'POST',
                                        Uri.parse(
                                            'http://127.0.0.1/stokvel_api/upload_proof_of_residence.php'));
                                    request.files.add(
                                        http.MultipartFile.fromBytes(
                                            'file', file.bytes!,
                                            filename: file.name));
                                    var response = await request.send();

                                    if (response.statusCode == 200) {
                                      print(
                                          'Proof of residence uploaded successfully');
                                    } else {
                                      print(
                                          'Failed to upload proof of residence');
                                    }
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                                icon: const Icon(Icons.file_upload,
                                    color: Colors.blue),
                                label: const Text('Upload File',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Copy of ID/Passport',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return Colors.white;
                                      }
                                      return Colors.black;
                                    },
                                  ),
                                ),
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    PlatformFile file = result.files.first;
                                    var request = http.MultipartRequest(
                                        'POST',
                                        Uri.parse(
                                            'http://127.0.0.1/stokvel_api/upload_copy_of_id.php'));
                                    request.files.add(
                                        http.MultipartFile.fromBytes(
                                            'file', file.bytes!,
                                            filename: file.name));
                                    var response = await request.send();

                                    if (response.statusCode == 200) {
                                      print(
                                          'Copy of identity uploaded successfully');
                                    } else {
                                      print(
                                          'Failed to upload copy of identity');
                                    }
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                                icon: const Icon(Icons.file_upload,
                                    color: Colors.blue),
                                label: const Text('Upload File',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),*/
                          const SizedBox(height: 30),
                          Container(
                            width: 400.0,
                            height: 40,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var regResult = register();
                                  regResult.then((result) async {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (result != 'Success') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Error"),
                                            content: const Text(
                                                "Opps!! Something went wrong"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Try again"),
                                                onPressed: () {
                                                  _formKey.currentState!
                                                      .reset();
                                                  Navigator.of(context).pop();
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
                                            title: const Row(
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Registration Success"),
                                              ],
                                            ),
                                            content: const Text(
                                                "Welcome to City United Stokvel\nYou can now log in"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return const LoginScreen();
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
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.blue),
                              ),
                              child: const Text('SUBMIT FORM'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 400.0,
                            height: 40,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.reset();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                                side: const BorderSide(color: Colors.blue),
                              ),
                              child: const Text('CLEAR FORM'),
                            ),
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
