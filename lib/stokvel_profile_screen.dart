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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Stokvel Profile Screen",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Stokvel"),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String choice) {
                if (choice == 'My Profile') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const UserProfileScreen();
                      },
                    ),
                  );
                } else if (choice == 'Logout') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Are you sure you want to logout?'),
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
                return ['My Profile', 'Logout'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.blueGrey,
                child: const SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 20)),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'images/icon.png',
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'City United Stokvel(Main Savings)',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Stokvel members names',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Available Balance',
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
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text(
                                  'Requested Balance',
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
          selectedFontSize: 16,
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
              switch (currentIndex) {
                // Stokvel "Statement" tab
                case 0:
                  setState(() {
                    _statementScreen;
                  });

                // Stokvel "Chat(s)" tab
                case 1:
                  setState(() {
                    _chatScreen;
                  });

                //Stokvel "Request(s)" tab
                case 2:
                  setState(() {
                    _requestScreen;
                  });
              }
            });
            return;
          },
          items: const [
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
            /*BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Me',
            ),*/
          ],
        ),
      ),
    );
  }

  // Statement nav bar tab screen
  Widget _statementScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                'Start a conversation',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Chat nav bar tab screen
  Widget _chatScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                'Start a conversation',
                style: TextStyle(fontSize: 24),
              ),
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
    );
  }

  Widget _requestScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                'View all stokvel request here',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
