import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stokvel/bottom_tabs/stokvel/chat_screen.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/screens/user_screen.dart';

class Request {
  final String id;
  final double amount;
  final String description;
  final bool isApproved;

  Request(this.id, this.amount, this.description, this.isApproved);
}

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({super.key});

  @override
  _PendingRequestScreenState createState() => _PendingRequestScreenState();
}

class _PendingRequestScreenState extends State<PendingRequestScreen> {
  int selectedItem = 2;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatementScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    }
    if (index == 2) {}
  }

  List<Request> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  void fetchRequests() {
    // TODO: Fetch requests from your database and update the state
    // For now, I'll just add some dummy data
    setState(() {
      requests = [
        Request('1', 100.0, 'Request 1', false),
        Request('2', 200.0, 'Request 2', false),
        Request('3', 300.0, 'Request 3', true),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedFontSize: 16,
        selectedItemColor: Colors.blue[800],
        currentIndex: selectedItem,
        onTap: updateItem,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Statement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat(s)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Request(s)',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            color: Colors.blueGrey,
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: SingleChildScrollView(
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
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              "City United Stokvel",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
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
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return const UserScreen();
                                                },
                                              ),
                                            );
                                          },
                                          child: const Text('My Profile',
                                              style: TextStyle(
                                                  color: Colors.black)),
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
                                                        Navigator.of(context)
                                                            .pop();
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
                            const SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Available Bal',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 20),
                                      ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                if (!requests[index].isApproved) {
                  return Container(
                    padding: const EdgeInsets.all(1),
                    margin: const EdgeInsets.all(2),
                    child: ListTile(
                      title: Text(requests[index].description),
                      subtitle: Text(
                          '\$${requests[index].amount.toStringAsFixed(2)}'),
                    ),
                  );
                } else {
                  return Container(); // return an empty container for approved requests
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}