import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:stokvel/screens/user_screen.dart";

class StokvelScreen extends StatefulWidget {
  const StokvelScreen({super.key});

  @override
  State<StokvelScreen> createState() {
    return _BottomNavigationBar();
  }
}

class _BottomNavigationBar extends State<StokvelScreen> {
  int selectedItem = 0;
  List itemLabels = [
    const Text(
      "Statement",
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    ),
    SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.blueGrey,
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      SizedBox(
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  image: const DecorationImage(
                                    image: AssetImage("images/icon.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Stokvel Name",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Stokvel Member",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                          builder: (BuildContext context) {
                                            return const UserScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text('My Profile',
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
                      ),
                      const SizedBox(height: 3),
                      const SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
          ),
        ],
      ),
    ),
    const Text(
      "Request(s)",
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    ),
  ];

  void updateItem(value) {
    setState(() {
      selectedItem = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey,
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
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Request(s)',
          ),
        ],
      ),
      body: Center(
        child: itemLabels[selectedItem],
      ),
    );
  }
}
