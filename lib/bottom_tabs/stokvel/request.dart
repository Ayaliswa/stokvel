import 'package:flutter/material.dart';
import 'package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/stokvel/chat_screen.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/header/stokvel.dart';

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
      bottomNavigationBar: StokvelNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: Column(
        children: [
          StokvelHearder(),
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
