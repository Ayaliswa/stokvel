import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stokvel/screens/stokvel_screen.dart';
import 'package:stokvel/security/change_password_screen.dart';

class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                                borderRadius: BorderRadius.circular(100),
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
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Welcome Back \nAyanda",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
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
                                        builder: (BuildContext context) {
                                          return const ChangePasswordScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text('Change my password',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const StokvelScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text('Stokvel Profile',
                                      style: TextStyle(color: Colors.black)),
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
                                                Navigator.of(context).pop();
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
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        isExpanded: true,
                        value: "City United Stokvel",
                        onChanged: (String? newValue) {},
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Available Bal',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20),
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
    );
  }
}
