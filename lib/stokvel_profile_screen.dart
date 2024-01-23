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
          title: const Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/icon.png'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'City United Stokvel(Main Savings)',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ayanda, Thomas, Mbuyisa, Asanda, Lusanda, Nothando',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: const Column(
          children: [
            Center(
              child: SizedBox(
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
                              style:
                                  TextStyle(color: Colors.green, fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'E4700.00',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Requested Balance',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'E950.00',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Spacer()
                      ],
                    ),
                  ],
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
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_quote),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}
