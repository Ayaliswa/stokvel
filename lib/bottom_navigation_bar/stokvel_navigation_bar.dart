import 'package:flutter/material.dart';

class StokvelNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  StokvelNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
          icon: Icon(Icons.chat),
          label: 'Chat(s)',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.request_page),
          label: 'Request(s)',
        ),
      ],
    );
  }
}
