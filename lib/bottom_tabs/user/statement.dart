import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/bottom_navigation_bar/user_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/user/request.dart';
import 'package:stokvel/bottom_tabs/user/transaction.dart';
import 'package:stokvel/header/user.dart';

class UserStatementScreen extends StatefulWidget {
  const UserStatementScreen({super.key});

  @override
  UserStatementScreenState createState() => UserStatementScreenState();
}

class UserStatementScreenState extends State<UserStatementScreen> {
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

  @override
  void initState() {
    super.initState();
    fetchMemberStokvelTransactions()
        .then((transactions) => groupTransactionsByMonth(transactions));
  }

  Future<List<dynamic>> fetchMemberStokvelTransactions() async {
    try {
      String? phoneNumber = await getPhoneByUsername();
      String url =
          "http://127.0.0.1/stokvel_api/fetchMemberStokvelTransactions.php?phoneNumber=$phoneNumber";

      Map<String, String?> body = {"phoneNumber": phoneNumber};
      dynamic response = await http.post(Uri.parse(url), body: body);

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

  void toggleExpansion(int index) {
    setState(() {
      isExpanded[index] = !isExpanded[index];
      if (isExpanded[index]) {
        fetchMemberStokvelTransactions().then((transactions) {
          groupedTransactions = groupTransactionsByMonth(transactions);
        });
      }
    });
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Future<String?> getPhoneByUsername() async {
    try {
      String username = await getUsername();
      String url =
          "http://127.0.0.1/stokvel_api/getPhoneByUsername.php?username=$username";

      Map<String, String> body = {"username": username};
      dynamic response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            return data;
          } else {
            return null;
          }
        } else {}
      } else {
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: UserNavigationBar(
            currentIndex: selectedItem,
            onTap: updateItem,
          ),
          body: Column(
            children: [
              const UserHeader(),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Description",
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
                      "Source of Fund",
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
                            reverse: true,
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
                                  }

                                  if (innerTransaction['Description'] ==
                                      description3) {
                                    totalAmountRequested += double.parse(
                                        innerTransaction['Amount']);
                                  }

                                  if (innerTransaction['Description'] ==
                                      description2) {
                                    totalRequestAmountPaid += double.parse(
                                        innerTransaction['Amount']);
                                  }

                                  if (innerTransaction['Description'] ==
                                      description3) {
                                    totalAmountRequestedWithInterest +=
                                        double.parse(innerTransaction['Repay']);
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

                                  totalAmountAvailable =
                                      (totalAmountContributed -
                                          totalAmountRequested);
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
                                        transaction['Description'],
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
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        transaction['Source'],
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
                child: FutureBuilder<List<dynamic>>(
                  future: fetchMemberStokvelTransactions(),
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
                                    transaction['Description'],
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
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    transaction['Source'],
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
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
