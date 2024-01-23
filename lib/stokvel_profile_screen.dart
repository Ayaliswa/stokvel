import 'package:flutter/material.dart';

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
          backgroundColor: Colors.blue,
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
                                'Group members names',
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
                                  'E4700.00',
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
                                  'E950.00',
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
            });
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
}
