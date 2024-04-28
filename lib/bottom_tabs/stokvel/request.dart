import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/stokvel/chat_screen.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/header/stokvel.dart';

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({super.key});

  @override
  PendingRequestScreenState createState() => PendingRequestScreenState();
}

class PendingRequestScreenState extends State<PendingRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Future<String>? approveResult;
  Future<String>? deleteResult;
  String description3 = "Loan Requested";
  bool _isLoading = false;
  Map<String, List<dynamic>>? groupedRequests;
  List<bool> isExpanded = List.generate(12, (_) => false);
  double totalAmountRequested = 0;

  int selectedItem = 2;
  final TextEditingController codeController = TextEditingController();
  final TextStyle orangeTextStyle =
      const TextStyle(color: Colors.deepOrangeAccent);

  @override
  void initState() {
    super.initState();
    //fetchStokvelTransactions();
    fetchStokvelRequests().then((requests) => groupRequestsByMonth(requests));
    //fetchStokvelTransactions().then((transactions) => groupTransactionsByMonth(transactions));
  }

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StokvelStatementScreen()),
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

  Future<List<dynamic>> fetchStokvelRequests() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/fetchStokvelRequests.php";
      dynamic response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var requestsData = json.decode(response.body);
        return requestsData;
      } else {
        throw Exception('Failed to fetch requests: ${response.statusCode}');
      }
    } catch (e) {
      throw ("No request \nto display yet\n\nclick on request tab on you profile page to make one");
    }
  }

  Map<String, List<dynamic>> groupRequestsByMonth(List<dynamic> requests) {
    Map<String, List<dynamic>> groupedRequests = {};
    for (var request in requests) {
      String dateString = request['Date'];
      DateTime date = DateTime.parse(dateString);
      String monthKey =
          "${date.year}-${(date.month - 1).toString().padLeft(2, '0')}";
      if (!groupedRequests.containsKey(monthKey)) {
        groupedRequests[monthKey] = [];
      }
      groupedRequests[monthKey]!.add(request);
    }
    return groupedRequests;
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
        // Fetch transactions for the expanded month
        fetchStokvelRequests().then((requests) {
          // Update _groupedTransactions with filtered transactions for the month
          groupedRequests = groupRequestsByMonth(requests);
        });
      }
    });
  }

  Future<String> saveStokvelTransaction(
      Map<String, dynamic> request, int selectedTabIndex) async {
    print('saveStokvelTransaction fuction called');
    try {
      String url = "http://127.0.0.1/stokvel_api/saveStokvelTransaction.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "memberPhone": request['Phone'],
        "depositer": "Stokvel",
        "amount": request['Amount'],
        "repay": request['Repay'],
        "description": description3,
        "source": "Stokvel",
        "timestamp": DateTime.now().toIso8601String(),
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
      return 'Failed to save transaction: $e';
    }
  }

  Future<String> deleteStokvelRequest(
      Map<String, dynamic> request, int selectedTabIndex) async {
    try {
      String url = "http://127.0.0.1/stokvel_api/deleteStokvelRequest.php";
      dynamic response = await http.post(Uri.parse(url), body: {
        "phone": request['Phone'],
        "name": request['Name'],
        "surname": request['Surname'],
        "amount": request['Amount'],
        "repay": request['Repay'],
        "receiver": request['Receiver'],
        "timestamp": request['Date'],
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
      return 'Failed to delete request: $e';
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
                      "Full Name",
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
                      "Phone No.",
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
                        if (isExpanded[(index)] && groupedRequests != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupedRequests![
                                        '${DateTime.now().year}-${(index).toString().padLeft(2, '0')}']
                                    ?.length ??
                                0,
                            itemBuilder: (context, innerIndex) {
                              final request = groupedRequests![
                                      '${DateTime.now().year}-${(index).toString().padLeft(2, '0')}']
                                  ?[innerIndex];

                              if (request != null) {
                                totalAmountRequested = 0;

                                for (var innerRequest in groupedRequests![
                                    '${DateTime.now().year}-${(index).toString().padLeft(2, '0')}']!) {
                                  totalAmountRequested +=
                                      double.parse(innerRequest['Amount']);
                                  print(
                                      "Total Amount Requested: E $totalAmountRequested");
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
                                              Icon(Icons.recommend_sharp,
                                                  color: Colors.green),
                                              Text(
                                                "Approve Request",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          content: const Text(
                                            "NOTE: Only admin can approve request",
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
                                                              const PendingRequestScreen()),
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
                                                                              const PendingRequestScreen()),
                                                                    );
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                    "Approve",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green),
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

                                                                      print(request[
                                                                          'Name']);
                                                                      print(request[
                                                                          'Surname']);
                                                                      print(
                                                                          'E ${request['Amount']}.00');
                                                                      print(request[
                                                                          'Phone']);
                                                                      print(request[
                                                                          'Date']);
                                                                      approveResult = saveStokvelTransaction(
                                                                          request,
                                                                          selectedTabIndex);
                                                                      approveResult
                                                                          ?.then(
                                                                        (result) async {
                                                                          setState(
                                                                              () {
                                                                            _isLoading =
                                                                                false;
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
                                                                                        "Failed to approve request\nTry again",
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
                                                                                              return const PendingRequestScreen();
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
                                                                            deleteResult =
                                                                                deleteStokvelRequest(request, selectedTabIndex);
                                                                            deleteResult?.then((result) async {
                                                                              setState(() {
                                                                                _isLoading = false;
                                                                              });
                                                                              if (result != 'Success') {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: const Text(
                                                                                        "Warning",
                                                                                        style: TextStyle(color: Colors.red),
                                                                                      ),
                                                                                      content: const Row(
                                                                                        children: [
                                                                                          Icon(Icons.warning_amber, color: Colors.amber),
                                                                                          Text(
                                                                                            "Request Approved but failed \nto delete it from pending\nTry again on long press",
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
                                                                                                  return const PendingRequestScreen();
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
                                                                                      content: const Text("Request Approved"),
                                                                                      actions: <Widget>[
                                                                                        TextButton(
                                                                                          child: const Text("Done"),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).push(
                                                                                              MaterialPageRoute(
                                                                                                builder: (BuildContext context) {
                                                                                                  return const PendingRequestScreen();
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
                                                                            });
                                                                          }
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                )
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
                                          request['Name'] +
                                              "  " +
                                              request['Surname'],
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'E ${request['Amount']}.00',
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: orangeTextStyle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          request['Phone'],
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          request['Date'],
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 1,
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
                        if (isExpanded[(index)] && groupedRequests != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Amount Requested: E $totalAmountRequested",
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
                  future: fetchStokvelRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (snapshot.hasData) {
                      final requestsData = snapshot.data!;
                      return ListView.builder(
                        itemCount: requestsData.length,
                        itemBuilder: (context, index) {
                          final request = requestsData[index];
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
                                          Icon(Icons.recommend_sharp,
                                              color: Colors.green),
                                          Text(
                                            "Approve Request",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      content: const Text(
                                        "NOTE: Only admin can approve request",
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
                                                          const PendingRequestScreen()),
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
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Enter Code",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
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
                                                                      color: Colors
                                                                          .black),
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                    icon: Icon(
                                                                      _obscureText
                                                                          ? Icons
                                                                              .visibility
                                                                          : Icons
                                                                              .visibility_off,
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
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const PendingRequestScreen()),
                                                                );
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                "Approve",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              onPressed: () {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  setState(() {
                                                                    _isLoading =
                                                                        true;
                                                                  });

                                                                  print(request[
                                                                      'Name']);
                                                                  print(request[
                                                                      'Surname']);
                                                                  print(
                                                                      'E ${request['Amount']}.00');
                                                                  print(request[
                                                                      'Phone']);
                                                                  print(request[
                                                                      'Date']);
                                                                  approveResult =
                                                                      saveStokvelTransaction(
                                                                          request,
                                                                          selectedTabIndex);
                                                                  approveResult
                                                                      ?.then(
                                                                    (result) async {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                      if (result !=
                                                                          'Success') {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: const Text(
                                                                                "Error",
                                                                                style: TextStyle(color: Colors.red),
                                                                              ),
                                                                              content: const Row(
                                                                                children: [
                                                                                  Icon(Icons.error_outline, color: Colors.red),
                                                                                  Text(
                                                                                    "Failed to approve request\nTry again",
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
                                                                                          return const PendingRequestScreen();
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
                                                                        deleteResult = deleteStokvelRequest(
                                                                            request,
                                                                            selectedTabIndex);
                                                                        deleteResult
                                                                            ?.then((result) async {
                                                                          setState(
                                                                              () {
                                                                            _isLoading =
                                                                                false;
                                                                          });
                                                                          if (result !=
                                                                              'Success') {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: const Text(
                                                                                    "Warning",
                                                                                    style: TextStyle(color: Colors.red),
                                                                                  ),
                                                                                  content: const Row(
                                                                                    children: [
                                                                                      Icon(Icons.warning_amber, color: Colors.amber),
                                                                                      Text(
                                                                                        "Request Approved but failed \nto delete it from pending\nTry again on long press",
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
                                                                                              return const PendingRequestScreen();
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
                                                                                  content: const Text("Request Approved"),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                      child: const Text("Done"),
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).push(
                                                                                          MaterialPageRoute(
                                                                                            builder: (BuildContext context) {
                                                                                              return const PendingRequestScreen();
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
                                                                        });
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                            )
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      request['Name'] +
                                          "  " +
                                          request['Surname'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'E ${request['Amount']}.00',
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: orangeTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      request['Phone'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      request['Date'],
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 1,
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
                      return const Center(
                        child: Text("No request found"),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),*/
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
