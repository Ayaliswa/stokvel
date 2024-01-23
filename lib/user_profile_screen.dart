import 'package:flutter/material.dart';
import 'stokvel_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "User Profile Screen",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue,
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/icon.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gama Sisana Bayanda',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '+268 7612-3456',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StokvelProfileScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        style: const TextStyle(fontSize: 20),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        padding: const EdgeInsets.only(left: 20, right: 20),
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
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: 400,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Available Balance',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'E100.00',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                    'Requested Balance',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'E50.00',
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
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Statement',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_quote),
              label: 'Request',
            ),
            /*BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Stokvel',
            ),*/
          ],
        ),
      ),
    );
  }
}
