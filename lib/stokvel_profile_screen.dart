import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user_profile_screen.dart';

class StokvelProfileScreen extends StatefulWidget {
  const StokvelProfileScreen({super.key});

  @override
  State<StokvelProfileScreen> createState() => _StokvelProfileScreenState();
}

class _StokvelProfileScreenState extends State<StokvelProfileScreen> {
  int currentIndex = 1;
  final _usernameController = TextEditingController();

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
                  width: 400,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.all(2)),
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                'images/icon.png',
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'City United Stokvel',
                                  //maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Member1, Member2',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
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
                                      'Available Bal...',
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
                                Column(
                                  children: [
                                    Text(
                                      'Requested Bal...',
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
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey,
          selectedFontSize: 16,
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
              switch (currentIndex) {
                // Stokvel "Statement" tab
                case 0:
                  _statementScreen;

                // Stokvel "Chat(s)" tab
                case 1:
                  _chatScreen;

                //Stokvel "Request(s)" tab
                case 2:
                  _requestScreen;
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
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
                'Start a conversation',
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

  // Chat nav bar tab screen
  Widget _chatScreen() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Text(
                'Start a conversation',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message here',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
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
