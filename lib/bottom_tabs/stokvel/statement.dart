import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/stokvel/chat_screen.dart';
import 'package:stokvel/bottom_tabs/stokvel/request.dart';
import 'package:stokvel/header/stokvel.dart';

class StokvelStatementScreen extends StatefulWidget {
  const StokvelStatementScreen({super.key});

  @override
  StokvelStatementScreenState createState() => StokvelStatementScreenState();
}

class StokvelStatementScreenState extends State<StokvelStatementScreen> {
  int selectedItem = 0;
  final TextStyle greenTextStyle = const TextStyle(color: Colors.green);
  final TextStyle redTextStyle = const TextStyle(color: Colors.red);

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

  @override
  void initState() {
    super.initState();
    fetchStokvelTransactions();
  }

  Future<List<dynamic>> fetchStokvelTransactions() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/fetchStokvelTransactions.php";

      dynamic response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var transactionsData = json.decode(response.body);
        return transactionsData;
      } else {
        throw Exception('Failed to fetch transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: StokvelNavigationBar(
            currentIndex: selectedItem,
            onTap: updateItem,
          ),
          body: Column(
            children: [
              const StokvelHeader(),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Phone No.",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Amount",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Description",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Date",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 2),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: fetchStokvelTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final transactions = snapshot.data!;
                      return ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      transaction['Phone'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'E ${transaction['Amount']}.00',
                                            style: (transaction[
                                                            'Description'] ==
                                                        'Monthly Contribution' ||
                                                    transaction[
                                                            'Description'] ==
                                                        'Loan Repayment')
                                                ? const TextStyle(
                                                    color: Colors.green)
                                                : const TextStyle(
                                                    color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      transaction['Description'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      transaction['Date'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
