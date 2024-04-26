import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  List<bool> isExpanded = List.generate(12, (_) => false);
  String description = "Monthly Contribution";
  String description2 = "Loan Repayment";
  String description3 = "Loan Requested";

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
      isExpanded[index] = !isExpanded[index];
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
    //fetchStokvelTransactions();
    fetchStokvelTransactions()
        .then((transactions) => groupTransactionsByMonth(transactions));
    //fetchStokvelTransactions().then((transactions) => groupTransactionsByMonth(transactions));
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

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Map<String, List<dynamic>> groupTransactionsByMonth(
      List<dynamic> transactions) {
    Map<String, List<dynamic>> groupedTransactions = {};
    for (var transaction in transactions) {
      String dateString = transaction['Date'];
      DateTime date = DateTime.parse(dateString);
      String monthKey =
          "${date.year}-${(date.month - 1).toString().padLeft(2, '0')}";
      if (!groupedTransactions.containsKey(monthKey)) {
        groupedTransactions[monthKey] = [];
      }
      groupedTransactions[monthKey]!.add(transaction);
    }
    return groupedTransactions;
  }

  Map<String, double> calculateMonthlyTotalDeposits(String description,
      String description2, Map<String, List<dynamic>> groupedTransactions) {
    Map<String, double> monthlyTotals = {};
    groupedTransactions.forEach((key, transactions) {
      double monthTotal = 0.0;
      for (var transaction in transactions) {
        if (transaction['Description'] == description ||
            transaction['Description'] == description2) {
          monthTotal += double.parse(transaction['Amount']);
        }
      }
      monthlyTotals[key] = monthTotal;
    });
    return monthlyTotals;
  }

  void toggleExpansion(int index) {
    setState(() {
      isExpanded[index] = !isExpanded[index];
      if (isExpanded[index]) {
        // Fetch transactions for the expanded month
        fetchStokvelTransactions().then((transactions) {
          // Update _groupedTransactions with filtered transactions for the month
          groupedTransactions = groupTransactionsByMonth(transactions);
        });
      }
    });
  }

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  Map<String, List<dynamic>>? groupedTransactions;

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
                      "Depositer",
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
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    String month = months[index];
                    return ExpansionTile(
                      title: Text(
                        month,
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onExpansionChanged: (isExpanded) =>
                          toggleExpansion(index),
                      children: [
                        if (isExpanded[(index)] && groupedTransactions != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupedTransactions![
                                        '${DateTime.now().year}-${(index).toString().padLeft(2, '0')}']
                                    ?.length ??
                                0,
                            itemBuilder: (context, innerIndex) {
                              final transaction = groupedTransactions![
                                      '${DateTime.now().year}-${(index).toString().padLeft(2, '0')}']
                                  ?[innerIndex];
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        transaction['Name'] +
                                            "\n" +
                                            transaction['Phone'],
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        maxLines: 2,
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
                              );
                            },
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Monthly Total Deposits: E"
                              "${groupedTransactions != null ? calculateMonthlyTotalDeposits(description, description2, groupedTransactions!).values.first : ''}",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.green),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Monthly Total Requests: E",
                              style: TextStyle(fontSize: 18, color: Colors.red),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Total Requests Repayed: E",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.green),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Monthly Available Balance: E",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.green),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Monthly Pending Requests: E",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.green),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  },
                ),
              ),
              /*Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: fetchStokvelTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final transactions = snapshot.data!;
                      return ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    transaction['Name'] +
                                        "\n" +
                                        transaction['Phone'],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'E ${transaction['Amount']}.00',
                                          style: (transaction['Description'] ==
                                                      'Monthly Contribution' ||
                                                  transaction['Description'] ==
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
              */
            ],
          ),
        ),
      ],
    );
  }
}
