import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/stokvel/chat_screen.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/header/stokvel.dart';

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({super.key});

  @override
  PendingRequestScreenState createState() => PendingRequestScreenState();
}

class PendingRequestScreenState extends State<PendingRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Future<String>? approveResult;
  Future<String>? deleteResult;
  bool _isLoading = false;

  int selectedItem = 2;
  final TextEditingController codeController = TextEditingController();
  final TextStyle orangeTextStyle =
      const TextStyle(color: Colors.deepOrangeAccent);

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StokvelStatementScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    }
    if (index == 2) {}
  }

  Future<List<dynamic>> fetchStokvelRequests() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/fetchStokvelRequests.php";
      dynamic response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var requestsData = json.decode(response.body);
        return requestsData;
      } else {
        throw Exception('Failed to fetch requests: ${response.statusCode}');
      }
    } catch (e) {
      throw ("No request \nto display yet\n\nclick on request tab on you profile page to make one");
    }
  }

  Future<String> saveStokvelTransaction() async {
    print('saveStokvelTransaction fuction called');
    try {
      String url = "http://127.0.0.1/stokvel_api/saveStokvelTransaction.php";
      print('save one');
      dynamic response = await http.post(Uri.parse(url), body: {
        "memberPhone": ['Phone'],
        "depositer": "Stokvel",
        "amount": ['Amount'],
        "description": "Requested",
        "source": "Stokvel",
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

  Future<String> deleteStokvelRequest() async {
    print('saveStokvelTransaction fuction called');
    try {
      String url = "http://127.0.0.1/stokvel_api/deleteStokvelRequest.php";
      print('save one');
      dynamic response = await http.post(Uri.parse(url), body: {
        "memberPhone": ['Phone'],
        "name": ['First Name'],
        "surname": ['Last Name'],
        "amount": ['Amount'],
        "description": ['Receiver'],
        "source": ['Date'],
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
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: StokvelNavigationBar(
            currentIndex: selectedItem,
            onTap: updateItem,
          ),
          body: Column(
            children: [
              const StokvelHeader(),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Full Name",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Amount",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Phone No.",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Date",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 2),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: fetchStokvelRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (snapshot.hasData) {
                      final requestsData = snapshot.data!;
                      return ListView.builder(
                        itemCount: requestsData.length,
                        itemBuilder: (context, index) {
                          final request = requestsData[index];
                          return ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Row(
                                      children: [
                                        Icon(Icons.recommend_sharp,
                                            color: Colors.green),
                                        Text(
                                          "Approve Request",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      "NOTE: Only admin can approve request",
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: const Text(
                                              "Back",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PendingRequestScreen()),
                                              );
                                            },
                                          ),
                                          TextButton(
                                            child: const Text(
                                              "Continue",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Enter Code",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                    content: Form(
                                                      key: _formKey,
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  codeController,
                                                              obscureText:
                                                                  _obscureText,
                                                              enableSuggestions:
                                                                  false,
                                                              autocorrect:
                                                                  false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "enter stokvel code",
                                                                hintStyle: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        16),
                                                                labelText:
                                                                    "Stokvel Code",
                                                                labelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18),
                                                                prefixIcon: const Icon(
                                                                    Icons.code,
                                                                    color: Colors
                                                                        .black),
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                suffixIcon:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    _obscureText
                                                                        ? Icons
                                                                            .visibility
                                                                        : Icons
                                                                            .visibility_off,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      _obscureText =
                                                                          !_obscureText;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return "Please enter stokvel code";
                                                                }
                                                                return null;
                                                              },
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            child: const Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const PendingRequestScreen()),
                                                              );
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                              "Approve",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            onPressed: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() {
                                                                  _isLoading =
                                                                      true;
                                                                });
                                                                approveResult =
                                                                    saveStokvelTransaction();
                                                                approveResult
                                                                    ?.then(
                                                                  (result) async {
                                                                    setState(
                                                                        () {
                                                                      _isLoading =
                                                                          false;
                                                                    });
                                                                    if (result !=
                                                                        'Success') {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text(
                                                                              "Error",
                                                                              style: TextStyle(color: Colors.red),
                                                                            ),
                                                                            content:
                                                                                const Row(
                                                                              children: [
                                                                                Icon(Icons.error_outline, color: Colors.red),
                                                                                Text(
                                                                                  "Failed to approve request\nTry again",
                                                                                  style: TextStyle(color: Colors.red),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: const Text("Try again"),
                                                                                onPressed: () {
                                                                                  codeController.clear();
                                                                                  Navigator.of(context).push(
                                                                                    MaterialPageRoute(
                                                                                      builder: (BuildContext context) {
                                                                                        return const PendingRequestScreen();
                                                                                      },
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    } else {
                                                                      deleteResult =
                                                                          deleteStokvelRequest();
                                                                      deleteResult
                                                                          ?.then(
                                                                              (result) async {
                                                                        setState(
                                                                            () {
                                                                          _isLoading =
                                                                              false;
                                                                        });
                                                                        if (result !=
                                                                            'Success') {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                title: const Text(
                                                                                  "Warning",
                                                                                  style: TextStyle(color: Colors.red),
                                                                                ),
                                                                                content: const Row(
                                                                                  children: [
                                                                                    Icon(Icons.warning_amber, color: Colors.amber),
                                                                                    Text(
                                                                                      "Request Approved but failed \nto delete it from pending\nTry again on long press",
                                                                                      style: TextStyle(color: Colors.red),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  TextButton(
                                                                                    child: const Text("OK"),
                                                                                    onPressed: () {
                                                                                      codeController.clear();
                                                                                      Navigator.of(context).push(
                                                                                        MaterialPageRoute(
                                                                                          builder: (BuildContext context) {
                                                                                            return const PendingRequestScreen();
                                                                                          },
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        } else {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                content: const Text("Request Approved"),
                                                                                actions: <Widget>[
                                                                                  TextButton(
                                                                                    child: const Text("Done"),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).push(
                                                                                        MaterialPageRoute(
                                                                                          builder: (BuildContext context) {
                                                                                            return const PendingRequestScreen();
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
                                                                );
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    request['Name'] + "  " + request['Surname'],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'E ${request['Amount']}.00',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: orangeTextStyle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    request['Phone'],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    request['Date'],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("No request found"),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
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
      ],
    );
  }
}

/*
class ApproveRequest extends StatefulWidget {
  const ApproveRequest({super.key});

  @override
  ApproveRequestState createState() => ApproveRequestState();
}

class ApproveRequestState extends State<ApproveRequest> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Future<String>? loginResult;
  bool _isLoading = false;
  final TextEditingController usernameOrPhoneController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameOrPhoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Screen",
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
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colors.blue,
              ),
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white.withOpacity(0.8),
            body: Center(
              child: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          minRadius: 100,
                          backgroundImage: AssetImage(
                            "images/loginphoto.png",
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        const Text(
                          "Welcome Back\n you've been missed",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
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
                        const SizedBox(height: 20.0),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login:",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: usernameOrPhoneController,
                          decoration: const InputDecoration(
                            hintText: "Username or Phone",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                            labelText: "Username",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter username";
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                            labelText: "Password",
                            labelStyle: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.black),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const PasswordResetScreen();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
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
                                loginResult = handleLogin();
                                loginResult?.then((result) async {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (result != 'Success') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Error",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: const Row(
                                            children: [
                                              Icon(Icons.error_outline,
                                                  color: Colors.red),
                                              Text(
                                                "The username and password \nmatch was not found",
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
                                                usernameOrPhoneController
                                                    .clear();
                                                passwordController.clear();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    storeUsername(
                                        usernameOrPhoneController.text);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const UserStatementScreen();
                                        },
                                      ),
                                    );
                                    /*showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content:
                                              const Text("Login Successful"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("Continue"),
                                              onPressed: () {
                                                storeUsername(
                                                    usernameOrPhoneController
                                                        .text);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return const UserStatementScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );*/
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                            child: const Text("LOGIN"),
                          ),
                        ),
                        /*FutureBuilder<String>(
                        future: loginResult,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            if (snapshot.data == 'Connection failed') {
                              // Clear the text form field and return to the screen
                              usernameController.clear();
                              passwordController.clear();
                              return const Text(
                                  'Connection failed. Please try again.');
                            } else if (snapshot.data ==
                                'Welcome Back to \nCity United Stokvel') {
                              return Container();
                            } else {
                              return Text(snapshot.data!);
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),*/
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(width: .2),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register...",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Are you Admin/Tressurer?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(width: .2),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminLoginScreen()),
                                );
                              },
                              child: const Text(
                                "Login here..",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
*/
