import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'stokvel_profile_screen.dart';
import 'stokvel_registration_screen.dart';
import 'registration_screen.dart';
import 'change_password_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.username});
  final String username;

  //const UserProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _currentIndex = <Widget>[
    Text(
      'Chat Screen Sample',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    Text(
      'Make your first request',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    Text(
      'Make your first request',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentIndex;
    });
  }

  get username => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "User Profile Screen",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("$username"),
                accountEmail: Text(""),
              ),
              // Other widgets for the user profile screen
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.blueGrey,
                child: SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 5)),
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/icon.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$username!',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '+268 7612-3456',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: () {
                                    (BuildContext context) => <PopupMenuEntry>[
                                          PopupMenuItem(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return const RegistrationForm();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text('Edit Profile',
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
                                                      return const ChangePasswordScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                  'Change Password',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green)),
                                            ),
                                          )
                                        ];
                                  },
                                  child: const Text('Me',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const StokvelProfileScreen();
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
                      const SizedBox(height: 2),
                      DropdownButton<String>(
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        padding: const EdgeInsets.all(3),
                        isExpanded: true,
                        value: 'City United Stokvel(Main Savings)',
                        onChanged: (String? newValue) {},
                        items: <String>[
                          'City United Stokvel(Main Savings)',
                          'City United Stokvel(Food Savings)',
                          'Group 3',
                          'Group 4'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 5),
                      const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Available Bal...',
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
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  'Requested Bal...',
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey,
          selectedFontSize: 16,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Statement',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Request',
            ),
          ],
        ),
      ),
    );
  }
}
