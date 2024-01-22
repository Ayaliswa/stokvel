import 'package:flutter/material.dart';

class StokvelProfileScreen extends StatefulWidget {
  const StokvelProfileScreen({super.key});

  @override
  State<StokvelProfileScreen> createState() => _StokvelProfileScreenState();
}

class _StokvelProfileScreenState extends State<StokvelProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'images/icon.png'), // Replace with user's profile photo
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'City Stokvel', // Replace with stokvel name
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(
                  'Ayanda, Thomas, Mbuyisa, Asanda, Lusanda, Nothando', // Replace with stokvel members
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: 400,
        child: Column(
          children: [
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
                      '\$100.00', // Replace with available balance
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Requested Balance',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\$50.00', // Replace with requested balance
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
                      '\$100.00', // Replace with available balance
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Amount',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\$50.00', // Replace with requested balance
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
            icon: Icon(Icons.chat),
            label: 'Chat',
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
    );
  }
}
