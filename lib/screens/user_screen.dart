import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:stokvel/bottom_navigation_bar/user_navigation_bar.dart";
import 'package:stokvel/security/change_password_screen.dart';
import "package:stokvel/screens/stokvel_screen.dart";
//import "package:stokvel/stokvel_profile_screen.dart";
import 'package:stokvel/registration/stokvel_registration_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() {
    return _BottomNavigationBar();
  }
}

class _BottomNavigationBar extends State<UserScreen> {
  int selectedItem = 0;
  List itemLabels = [
    // Statement screen tab
    const Text("Screen"),
    // Transaction screen tab
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: SizedBox(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      child: Column(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                        image: AssetImage("images/MoMo.jpeg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                        image: AssetImage("images/eMali.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                        image: AssetImage("images/Visa.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.start,
                          "Deposit via MoMo account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: '76416393',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Phone Number',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.phone, color: Colors.black),
                        // border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter source of fund';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: 'How much do you want to deposit',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Amount',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.money, color: Colors.black),
                        // border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.green),
                            ),
                            child: const Text('SEND...'),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {},
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
        )
      ],
    ),
    // Request loan screen tab
    const Text("Screen")
  ];

  void updateItem(value) {
    setState(() {
      selectedItem = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UserNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: SafeArea(
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
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return const StokvelRegistrationForm();
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text('Create stokvel',
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
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
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
              Center(
                child: itemLabels[selectedItem],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
