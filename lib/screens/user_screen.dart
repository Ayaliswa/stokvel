import "package:flutter/material.dart";
import "package:stokvel/bottom_navigation_bar/user_navigation_bar.dart";
import "package:stokvel/header/user.dart";

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() {
    return _BottomNavigationBar();
  }
}

class _BottomNavigationBar extends State<UserScreen> {
  int selectedItem = 0;
  List itemLabels = [
    // Statement screen tab
    const Text("Screen"),
    // Transaction screen tab

    // Request loan screen tab
    const Text("Screen")
  ];

  void updateItem(value) {
    setState(() {
      selectedItem = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UserNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserHeader(),
              Center(
                child: itemLabels[selectedItem],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
