import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/registration/stokvel_members.dart';
import 'package:stokvel/security/login_screen.dart';

class StokvelInfo extends StatefulWidget {
  const StokvelInfo({super.key});

  @override
  State<StokvelInfo> createState() => _StokvelInfoState();
}

class _StokvelInfoState extends State<StokvelInfo> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Future<String>? codeResult;
  bool _isLoading = false;
  final TextEditingController codeController = TextEditingController();

  Future<List<dynamic>>? fetchStokvelMembers() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/fetchStokvelMembers.php";

      dynamic response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var membersData = json.decode(response.body);
        return membersData;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to fetch transactions: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchStokvelTransactions: $e');
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<String> countStokvelMembers() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/countStokvelMembers.php";

      dynamic response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var totalMembers = json.decode(response.body);
        return totalMembers;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to count members: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in countStokvelMembers: $e');
      throw Exception('Failed to count members');
    }
  }

  Future<String> countRegisteredStokvelMembers() async {
    try {
      String url =
          "http://127.0.0.1/stokvel_api/countRegisteredStokvelMembers.php";

      dynamic response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var registeredMembers = json.decode(response.body);
        return registeredMembers;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception(
            'Failed to count registered members: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in countRegisteredStokvelMembers: $e');
      throw Exception('Failed to count registered members: $e');
    }
  }

  Future<String>? adminCodeAuth() async {
    try {
      String username = await getUsername();
      String url = "http://127.0.0.1/stokvel_api/adminCodeAuth.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "username": username,
        "code": codeController.text,
      });
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      print('Exception in adminLogin: $e');
      return 'Login failed: $e';
      //return 'Login failed: ${e.toString()}';
    }
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text("Stokvel Information"),
              backgroundColor: Colors.blue,
              actions: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Stokvel Code",
                                style: TextStyle(color: Colors.red),
                              ),
                              content: TextFormField(
                                controller: codeController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  hintText: "enter stokvel code",
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  labelText: "Stokvel Code",
                                  labelStyle: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  prefixIcon: const Icon(Icons.code,
                                      color: Colors.black),
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
                                    return "Please enter stokvel code";
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.start,
                              ),
                              actions: <Widget>[
                                Row(
                                  children: [
                                    TextButton(
                                      child: const Text("BACK"),
                                      onPressed: () {
                                        codeController.clear();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("SUBMIT"),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          codeResult = adminCodeAuth();
                                          codeResult?.then((result) async {
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
                                                          color: Colors.red),
                                                    ),
                                                    content: const Row(
                                                      children: [
                                                        Icon(
                                                            Icons.error_outline,
                                                            color: Colors.red),
                                                        Text(
                                                          "Code rejected",
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
                                                          codeController
                                                              .clear();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return const AddMembersScreen();
                                                  },
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.person_add),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.blueGrey,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10.0),
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            'images/icon.png',
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'City United Stokvel',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FutureBuilder<String>(
                              future: countRegisteredStokvelMembers(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Text(
                                    snapshot.data ?? '0',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  );
                                }
                              },
                            ),
                            const Text(" / "),
                            FutureBuilder<String>(
                              future: countStokvelMembers(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Text(
                                    snapshot.data?.toString() ?? '0',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "Stokvel Code",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content: Expanded(
                                        child: TextFormField(
                                          controller: codeController,
                                          obscureText: _obscureText,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: "enter stokvel code",
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                            labelText: "Stokvel Code",
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                            prefixIcon: const Icon(Icons.code,
                                                color: Colors.black),
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
                                              return "Please enter stokvel code";
                                            }
                                            return null;
                                          },
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          children: [
                                            TextButton(
                                              child: const Text("BACK"),
                                              onPressed: () {
                                                codeController.clear();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text("SUBMIT"),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  codeResult = adminCodeAuth();
                                                  codeResult
                                                      ?.then((result) async {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    if (result != 'Success') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              "Error",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            content: const Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .error_outline,
                                                                    color: Colors
                                                                        .red),
                                                                Text(
                                                                  "Invalid code",
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
                                                                  codeController
                                                                      .clear();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return const AddMembersScreen();
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Add Member',
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stokvel Banking:',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'MTN MoMo: +268 ',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '76416393',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'MTN MoMo: +268 ',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '79081803',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Stokvel Members:',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Full Name",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Phone No.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Location",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                    future: fetchStokvelMembers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final members = snapshot.data!;
                        return ListView.builder(
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      member['First Name'] +
                                          " " +
                                          member['Last Name'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      member['Phone Number'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      member['Physical Address'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
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
                          child: Text("No registered member found"),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                'Are you sure you want to leave the stokvel?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'You are no longer part of the stokvel'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
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
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Exit Stokvel",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 10)
              ],
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
