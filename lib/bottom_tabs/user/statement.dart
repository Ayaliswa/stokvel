import 'package:flutter/material.dart';
import 'package:stokvel/bottom_navigation_bar/user_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/user/request.dart';
import 'package:stokvel/bottom_tabs/user/transaction.dart';
import 'package:stokvel/header/user.dart';

class Statement {
  final String id;
  final double amount;
  final String description;

  Statement(this.id, this.amount, this.description);
}

class UserStatementScreen extends StatefulWidget {
  const UserStatementScreen({super.key});

  @override
  UserStatementScreenState createState() => UserStatementScreenState();
}

class UserStatementScreenState extends State<UserStatementScreen> {
  int selectedItem = 0;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {}
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserTransactionScreen(),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserRequestScreen(),
        ),
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
      bottomNavigationBar: UserNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: Column(
        children: [
          const UserHeader(),
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
