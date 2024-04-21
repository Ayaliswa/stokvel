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
    fetchMemberStokvelTransactions();
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
        } else {
          // ... handle other status codes
        }
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
