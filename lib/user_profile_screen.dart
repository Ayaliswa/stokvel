import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('User Profile'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                // Display settings
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        body: SizedBox(
          width: 400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'images/icon.png'), // Replace with user's profile photo
                    backgroundColor: Colors.transparent,
                  ),
                  Column(
                    children: [
                      Text(
                        'Username', // Replace with user's username
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
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
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: 'Group 1', // Replace with user's selected group
                onChanged: (String? newValue) {
                  // Update user's selected group
                },
                items: <String>['Group 1', 'Group 2', 'Group 3', 'Group 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '\$100.00', // Replace with user's available balance
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '\$100.00', // Replace with user's available balance
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(fontSize: 20),
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
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show buttons
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
