import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stokvel/bottom_tabs/stokvel/chat_screen.dart';
import 'package:stokvel/bottom_tabs/stokvel/request.dart';
import 'package:stokvel/screens/user_screen.dart';

class Statement {
  final String id;
  final double amount;
  final String description;

  Statement(this.id, this.amount, this.description);
}

class StatementScreen extends StatefulWidget {
  @override
  _StatementScreenState createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  int selectedItem = 0;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {}
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PendingRequestScreen()),
      );
    }
  }

  List<Statement> statements = [];

  @override
  void initState() {
    super.initState();
    fetchStatements();
  }

  void fetchStatements() {
    // TODO: Fetch statements from your database and update the state
    // For now, I'll just add some dummy data
    setState(() {
      statements = [
        Statement('1', 100.0, 'Statement 1'),
        Statement('2', 200.0, 'Statement 2'),
        Statement('3', 300.0, 'Statement 3'),
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
              itemCount: statements.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(statements[index].description),
                    subtitle: Text(
                        '\$${statements[index].amount.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
