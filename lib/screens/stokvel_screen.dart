import "package:flutter/material.dart";
import "package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart";
import "package:stokvel/bottom_tabs/stokvel/chat_screen.dart";
import "package:stokvel/bottom_tabs/stokvel/request.dart";
import "package:stokvel/bottom_tabs/stokvel/statement.dart";
import "package:stokvel/header/stokvel.dart";

class StokvelScreen extends StatefulWidget {
  const StokvelScreen({super.key});

  @override
  State<StokvelScreen> createState() {
    return _BottomNavigationBar();
  }
}

class _BottomNavigationBar extends State<StokvelScreen> {
  int selectedItem = 0;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StokvelStatementScreen()),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StokvelNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StokvelHearder(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                        textAlign: TextAlign.center,
                        "Welcome to\nCity United Stokvel\nUse the navigation bar below to change to different pages\n\nPress any tab below to hide this welcome",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
