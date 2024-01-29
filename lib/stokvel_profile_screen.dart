import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stokvel/stokvel_info.dart';
import 'user_profile_screen.dart';

class StokvelProfileScreen extends StatefulWidget {
  const StokvelProfileScreen({super.key});

  @override
  State<StokvelProfileScreen> createState() => _StokvelProfileScreenState();
}

class _StokvelProfileScreenState extends State<StokvelProfileScreen> {
  final _usernameController = TextEditingController();

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final tabs = [
    const Center(
      child: Text("View stokvel history statement"),
    ),
    Center(
      child: SizedBox(
        width: 400,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Type your message here',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {},
            ),
          ),
        ),
      ),
    ),
    const Center(
      child: Text("All stokvel request"),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Stokvel Profile Screen",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.blueGrey,
                child: SizedBox(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 70,
                          child: Row(
                            children: [
                              const Padding(padding: EdgeInsets.all(2)),
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                  'images/icon.png',
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      'City United Stokvel',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ),
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
                                      'Member1, Member2',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              PopupMenuButton<String>(
                                onSelected: (String choice) {
                                  if (choice == 'My Profile') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return UserProfileScreen(
                                            username: _usernameController.text,
                                          );
                                        },
                                      ),
                                    );
                                  } else if (choice == 'Logout') {
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
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return ['My Profile', 'Logout']
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: SizedBox(
                            width: 400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Text(
                                      'Available Balance',
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
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
                                      'Requested Balance',
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
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
              ),
            ),
            const Spacer(),
            tabs[_selectedIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Request(s)',
            ),
          ],
        ),
      ),
    );
  }

  // Statement nav bar tab screen
  Widget _statementScreen() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Text(
                'View Stokvel Statement',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestScreen() {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'View all stokvel request here',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
