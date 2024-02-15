import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/security/change_password_screen.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  UserHeaderState createState() => UserHeaderState();
}

class UserHeaderState extends State<UserHeader> {
  String? dropdownValue;

  Future<String> getUserInfo() async {
    final username = FirebaseAuth.instance.currentUser;
    if (username != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Login')
          .doc(username.uid)
          .get();
      return doc.data()?['Phone'] ?? doc.data()?['Username'] ?? '';
    } else {
      return '';
    }
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
              padding: const EdgeInsets.all(5),
              color: Colors.blueGrey,
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(height: 25.0),
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
                                          image: AssetImage("images/icon.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  FutureBuilder<String>(
                                    future: getUserInfo(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(); // show a loading spinner while waiting
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Welcome Back \n${snapshot.data}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const Spacer(),
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
                                          child: const Text('Stokvel Profile',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
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
                                                      child: const Text('Yes'),
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
                            SizedBox(
                              child: DropdownButton<String>(
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                isExpanded: true,
                                value: dropdownValue,
                                hint: const Text("select group"),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'City United Stokvel',
                                  'City United Stokvel(Food Savings)',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const SizedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Available Bal',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'E 0.00',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          'Requested Bal',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 20),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'E 0.00',
                                          style: TextStyle(fontSize: 20),
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
