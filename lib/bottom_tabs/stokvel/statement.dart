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
  Map<String, List<dynamic>>? groupedTransactions;
  double totalAmount = 0;
  double totalAmountContributed = 0;
  double totalAmountRequested = 0;
  double totalAmountRequestedWithInterest = 0;
  double totalAmountAvailable = 0;
  double totalRequestAmountPaid = 0;
  double totalRequestAmountPending = 0;

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

  Map<String, double> groupTransactionsByMonthWithTotal(
      List<dynamic> transactions) {
    Map<String, double> groupedTotals = {};
    for (var transaction in transactions) {
      String dateString = transaction['Date'];
      DateTime date = DateTime.parse(dateString);
      String monthKey =
          "${date.year}-${(date.month - 1).toString().padLeft(2, '0')}";

      if (!groupedTotals.containsKey(monthKey)) {
        groupedTotals[monthKey] = 0.0;
      }

      double? amount = transaction['Amount']?.toDouble();
      groupedTotals[monthKey] = amount!;
    }
    return groupedTotals;
  }

  Map<String, Map<String, double>> calculateMonthlyTotalsByDescription(
    List<dynamic> transactions,
  ) {
    Map<String, Map<String, double>> groupedTotals = {};
    for (var transaction in transactions) {
      String dateString = transaction['Date'];
      DateTime date = DateTime.parse(dateString);
      String monthKey =
          "${date.year}-${(date.month - 1).toString().padLeft(2, '0')}";

      if (!groupedTotals.containsKey(monthKey)) {
        groupedTotals[monthKey] = {
          'Requested': 0.0,
          'Contributed': 0.0,
          'PendingRequest': 0.0,
        };
      }

      String description = transaction['Description'];
      double amount = transaction['Amount'];

      if (description == 'description3') {
        groupedTotals[monthKey]?['Requested'] =
            (groupedTotals[monthKey]?['Requested'] ?? 0.0) + amount;
      } else {
        groupedTotals[monthKey]?['Contributed'] =
            (groupedTotals[monthKey]?['Contributed'] ?? 0.0) + amount;
        if (description == 'description2') {
          groupedTotals[monthKey]?['PendingRequest'] =
              (groupedTotals[monthKey]?['PendingRequest'] ?? 0.0) + amount;
        }
      }
    }

    for (var monthKey in groupedTotals.keys) {
      Map<String, double> monthTotals = groupedTotals[monthKey]!;
      monthTotals['PendingRequest'] =
          monthTotals['Requested']! - monthTotals['PendingRequest']!;
    }

    return groupedTotals;
  }

  Map<String, double> calculateMonthlyTotalDeposits(
      String description, Map<String, List<dynamic>> groupedTransactions) {
    Map<String, double> monthlyTotals = {};

    groupedTransactions.forEach((key, transactions) {
      double monthTotal = 0.0;
      bool isApril = key == "2024-04" || key.endsWith(" (Expanded)");

      if (isApril) {
        for (var transaction in transactions) {
          if (transaction['Description'] == description) {
            monthTotal += double.parse(transaction['Amount']);
          }
        }
        monthlyTotals[key] =
            monthTotal; // Update total for "2024-04" or its expanded form
      }
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

                              if (transaction != null) {
                                totalAmount = 0;
                                totalAmountContributed = 0;
                                totalAmountRequested = 0;
                                totalAmountRequestedWithInterest = 0;
                                totalRequestAmountPaid = 0;
                                totalAmountAvailable = 0;
                                totalRequestAmountPending = 0;

                                for (var innerTransaction in groupedTransactions![
                                    '${DateTime.now().year}-${(index).toString().padLeft(2, '0')}']!) {
                                  totalAmount +=
                                      double.parse(innerTransaction['Amount']);
                                  if (innerTransaction['Description'] !=
                                      description3) {
                                    totalAmountContributed += double.parse(
                                        innerTransaction['Amount']);
                                    print(
                                        "Total Amount Contributed: E $totalAmountContributed");
                                  }

                                  if (innerTransaction['Description'] ==
                                      description3) {
                                    totalAmountRequested += double.parse(
                                        innerTransaction['Amount']);
                                    print(
                                        "Total Amount Requested: E $totalAmountRequested");
                                  }

                                  if (innerTransaction['Description'] ==
                                      description2) {
                                    totalRequestAmountPaid += double.parse(
                                        innerTransaction['Amount']);
                                    print(
                                        "Total Amount Request Paid: E $totalRequestAmountPaid");
                                  }

                                  if (innerTransaction['Description'] ==
                                      description3) {
                                    totalAmountRequestedWithInterest +=
                                        double.parse(innerTransaction['Repay']);
                                    print(
                                        "Total Amount Request Not Paid: E $totalAmountRequestedWithInterest");
                                  }

                                  if (totalRequestAmountPaid != 0 &&
                                      totalAmountRequested != 0) {
                                    totalRequestAmountPending =
                                        totalAmountRequestedWithInterest -
                                            totalRequestAmountPaid;
                                  } else if (totalAmountRequested != 0) {
                                    totalRequestAmountPending =
                                        totalAmountRequestedWithInterest;
                                  }

                                  totalAmountAvailable = totalAmountContributed;
                                  print(
                                      "Total Amount Available: E $totalAmountAvailable");
                                }
                              }

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
                        if (isExpanded[(index)] && groupedTransactions != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Amount Contributed: E $totalAmountContributed",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "Total Amount Requested: E $totalAmountRequested",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "Total Requests Repayed: E $totalRequestAmountPaid",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Monthly Available Balance: E $totalAmountAvailable",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "Monthly Pending Requests: E $totalRequestAmountPending",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Monthly Total Deposits: E",
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
              ),*/
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
