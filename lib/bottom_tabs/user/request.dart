import 'package:flutter/material.dart';
import 'package:stokvel/bottom_navigation_bar/user_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/user/statement.dart';
import 'package:stokvel/bottom_tabs/user/transaction.dart';
import 'package:stokvel/header/user.dart';

class Request {
  final String id;
  final double amount;
  final String description;
  final bool isApproved;

  Request(this.id, this.amount, this.description, this.isApproved);
}

class UserRequestScreen extends StatefulWidget {
  const UserRequestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserRequestScreenState createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends State<UserRequestScreen> {
  int selectedItem = 2;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserStatementScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserTransactionScreen()),
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
      bottomNavigationBar: UserNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: Column(
        children: [
          const UserHeader(),
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
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
