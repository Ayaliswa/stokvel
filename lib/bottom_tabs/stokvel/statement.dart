import 'package:flutter/material.dart';
import 'package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/stokvel/chat_screen.dart';
import 'package:stokvel/bottom_tabs/stokvel/request.dart';
import 'package:stokvel/header/stokvel.dart';

class Statement {
  final String id;
  final double amount;
  final String description;

  Statement(this.id, this.amount, this.description);
}

class StokvelStatementScreen extends StatefulWidget {
  const StokvelStatementScreen({super.key});

  @override
  _StokvelStatementScreenState createState() => _StokvelStatementScreenState();
}

class _StokvelStatementScreenState extends State<StokvelStatementScreen> {
  int selectedItem = 0;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {}
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PendingRequestScreen()),
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
      bottomNavigationBar: StokvelNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: Column(
        children: [
          StokvelHearder(),
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
