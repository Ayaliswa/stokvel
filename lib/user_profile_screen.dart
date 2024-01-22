import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stokvel'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'images/icon.png'), // Replace with user's profile photo
                      backgroundColor: Colors.transparent,
                    ),
                    Column(
                      children: [
                        const Text(
                          'G. Bayanda', // Replace with user's username
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to user profile details
                          },
                          child: Text('View Profile'),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        // Display settings
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: 'Savings stokvel',
                  onChanged: (String? newValue) {
                    // Update user's selected group
                  },
                  items: <String>[
                    'Savings stokvel',
                    'Food stokvel',
                    'Group 3',
                    'Group 4'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
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
                              style:
                                  TextStyle(color: Colors.green, fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '\$100.00',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              'Requested Balance',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '\$50.00', // Replace with user's requested balance
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
      bottomNavigationBar: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavigationBar(
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
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Stack(
                  children: [
                    Positioned(
                      top: 100,
                      left: 20,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 20,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                      ),
                    ),
                  ],
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
