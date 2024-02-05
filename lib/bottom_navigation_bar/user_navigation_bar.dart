import 'package:flutter/material.dart';

class UserNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  UserNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedFontSize: 16,
      selectedItemColor: Colors.blue[800],
      currentIndex: currentIndex,
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Statement',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.currency_exchange),
          label: 'Transaction',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.request_page),
          label: 'Request Loan',
        ),
      ],
    );
  }
}
