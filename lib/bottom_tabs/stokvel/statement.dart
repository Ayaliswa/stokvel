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
  final _formKey = GlobalKey<FormState>();
  int selectedItem = 0;
  bool _isLoading = false;
  bool _obscureText = true;
  Future<String>? codeResult;
  Future<String>? deleteResult;
  final TextEditingController codeController = TextEditingController();
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
    fetchStokvelTransactions()
        .then((transactions) => groupTransactionsByMonth(transactions));
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

  void toggleExpansion(int index) {
    setState(() {
      isExpanded[index] = !isExpanded[index];
      if (isExpanded[index]) {
        fetchStokvelTransactions().then((transactions) {
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

  Future<String>? adminCodeAuth() async {
    try {
      String username = await getUsername();
      String url = "http://127.0.0.1/stokvel_api/adminCodeAuth.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "username": username,
        "code": codeController.text,
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        return "Error";
      } else {
        return "Success";
      }
    } catch (e) {
      return 'Login failed: $e';
      //return 'Login failed: ${e.toString()}';
    }
  }

  Future<String> deleteStokvelTransaction(
      Map<String, dynamic> transaction, int selectedTabIndex) async {
    try {
      String url = "http://127.0.0.1/stokvel_api/deleteStokvelTransaction.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "phone": transaction['Phone'],
        "name": transaction['Name'],
        "amount": transaction['Amount'],
        "repay": transaction['Repay'],
        "description": transaction['Description'],
        "source": transaction['Source'],
        "timestamp": transaction['Date'],
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data == "Error") {
          return 'Error';
        } else {
          return 'Success';
        }
      } else {
        return 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      return 'Failed to delete transaction: $e';
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

                              int selectedTabIndex = 1;
                              return GestureDetector(
                                child: ListTile(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.green),
                                              Text(
                                                "Delete Transaction",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          content: const Text(
                                            "NOTE: Only admin can delete transaction if amount not received",
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  child: const Text(
                                                    "Back",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const StokvelStatementScreen()),
                                                    );
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    "Continue",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            "Enter Code",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                          content: Form(
                                                            key: _formKey,
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        codeController,
                                                                    obscureText:
                                                                        _obscureText,
                                                                    enableSuggestions:
                                                                        false,
                                                                    autocorrect:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          "enter stokvel code",
                                                                      hintStyle: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              16),
                                                                      labelText:
                                                                          "Stokvel Code",
                                                                      labelStyle: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              18),
                                                                      prefixIcon: const Icon(
                                                                          Icons
                                                                              .code,
                                                                          color:
                                                                              Colors.black),
                                                                      border:
                                                                          const OutlineInputBorder(),
                                                                      suffixIcon:
                                                                          IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          _obscureText
                                                                              ? Icons.visibility
                                                                              : Icons.visibility_off,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            _obscureText =
                                                                                !_obscureText;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return "Please enter stokvel code";
                                                                      }
                                                                      return null;
                                                                    },
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const StokvelStatementScreen()),
                                                                    );
                                                                  },
                                                                ),
                                                                TextButton(
                                                                    child:
                                                                        const Text(
                                                                      "Approve",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.green),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      if (_formKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        setState(
                                                                            () {
                                                                          _isLoading =
                                                                              true;
                                                                        });
                                                                        codeResult =
                                                                            adminCodeAuth();
                                                                        codeResult
                                                                            ?.then(
                                                                          (result) async {
                                                                            setState(() {
                                                                              _isLoading = false;
                                                                            });
                                                                            if (result !=
                                                                                'Success') {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    title: const Text(
                                                                                      "Error",
                                                                                      style: TextStyle(color: Colors.red),
                                                                                    ),
                                                                                    content: const Row(
                                                                                      children: [
                                                                                        Icon(Icons.error_outline, color: Colors.red),
                                                                                        Text(
                                                                                          "Code rejected",
                                                                                          style: TextStyle(color: Colors.red),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    actions: <Widget>[
                                                                                      TextButton(
                                                                                        child: const Text("Try again"),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                          codeController.clear();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            } else {
                                                                              deleteResult = deleteStokvelTransaction(transaction, selectedTabIndex);
                                                                              deleteResult?.then(
                                                                                (result) async {
                                                                                  setState(() {
                                                                                    _isLoading = false;
                                                                                  });
                                                                                  if (result != 'Success') {
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          title: const Text(
                                                                                            "Error",
                                                                                            style: TextStyle(color: Colors.red),
                                                                                          ),
                                                                                          content: const Row(
                                                                                            children: [
                                                                                              Icon(Icons.error_outline, color: Colors.red),
                                                                                              Text(
                                                                                                "Failed to delete transaction\nTry again",
                                                                                                style: TextStyle(color: Colors.red),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          actions: <Widget>[
                                                                                            TextButton(
                                                                                              child: const Text("Try again"),
                                                                                              onPressed: () {
                                                                                                codeController.clear();
                                                                                                Navigator.of(context).push(
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (BuildContext context) {
                                                                                                      return const StokvelStatementScreen();
                                                                                                    },
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  } else {
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          title: const Text(
                                                                                            "Deleted",
                                                                                            style: TextStyle(color: Colors.red),
                                                                                          ),
                                                                                          content: const Row(
                                                                                            children: [
                                                                                              Icon(Icons.check, color: Colors.amber),
                                                                                              Text(
                                                                                                "Transaction deleted successfully",
                                                                                                style: TextStyle(color: Colors.red),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          actions: <Widget>[
                                                                                            TextButton(
                                                                                              child: const Text("OK"),
                                                                                              onPressed: () {
                                                                                                codeController.clear();
                                                                                                Navigator.of(context).push(
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (BuildContext context) {
                                                                                                      return const StokvelStatementScreen();
                                                                                                    },
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                },
                                                                              );
                                                                            }
                                                                          },
                                                                        );
                                                                      }
                                                                    })
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
