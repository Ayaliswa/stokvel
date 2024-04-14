import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/security/change_password_screen.dart';
import 'package:stokvel/stokvel_member_info.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  UserHeaderState createState() => UserHeaderState();
}

class UserHeaderState extends State<UserHeader> {
  String description = "Monthly Contribution";
  String description2 = "Loan Repayment";

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
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to fetch transactions: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in getStokvelTotalContributions: $e');
      throw Exception('Failed to fetch stokvel available balance: $e');
    }
  }

  Future<String> getMemberTotalRequested() async {
    try {
      String? phoneNumber = await getPhoneByUsername();
      String url =
          "http://127.0.0.1/stokvel_api/getMemberTotalRequested.php?phoneNumber=$phoneNumber";

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
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to fetch requested: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in getStokvelTotalRequested: $e');
      throw Exception('Failed to fetch stokvel requested total: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.blueGrey,
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: SizedBox(
                        child: Flexible(
                          child: Column(
                            children: [
                              const SizedBox(height: 20.0),
                              SizedBox(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: const DecorationImage(
                                            image:
                                                AssetImage("images/icon.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 1,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: FutureBuilder<String>(
                                        future: getUsername(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else {
                                            return Column(
                                              children: [
                                                const Text(
                                                  "Welcome Back",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "${snapshot.data}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    fontSize: 26,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return const StokvelMemberInfo();
                                              },
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return const ChangePasswordScreen();
                                                  },
                                                ),
                                              );
                                            },
                                            child: const Text(
                                                'Change my password',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return const StokvelStatementScreen();
                                                  },
                                                ),
                                              );
                                            },
                                            child: const Text('View Stokvel',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Are you sure you want to logout?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('No'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('Yes'),
                                                        onPressed: () {
                                                          SystemNavigator.pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Logout',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red)),
                                          ),
                                        ),
                                      ],
                                      icon: const Icon(Icons.more_vert),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const StokvelStatementScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'C_U_Stokvel Savings',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          FutureBuilder<String>(
                                            future:
                                                getMemberTotalContributions(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else {
                                                return Column(
                                                  children: [
                                                    const Text(
                                                      'Available Balance',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      "E ${snapshot.data ?? '0'}.00",
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          FutureBuilder<String>(
                                            future: getMemberTotalRequested(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else {
                                                return Column(
                                                  children: [
                                                    const Text(
                                                      'Requested',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      "E ${snapshot.data ?? '0'}.00",
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ],
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
            ),
          ],
        ),
      ),
    );
  }
}
