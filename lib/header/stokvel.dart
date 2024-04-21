import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stokvel/bottom_tabs/user/statement.dart';
import 'package:stokvel/security/login_screen.dart';
import 'package:stokvel/stokvel_info.dart';

class StokvelHeader extends StatefulWidget {
  const StokvelHeader({super.key});

  @override
  StokvelHeaderState createState() => StokvelHeaderState();
}

class StokvelHeaderState extends State<StokvelHeader> {
  String description = "Monthly Contribution";
  String description2 = "Loan Repayment";

  Future<String?> getStokvelTotalContributions() async {
    try {
      String url =
          "http://127.0.0.1/stokvel_api/getStokvelTotalContributions.php";

      Map<String, String?> body = {
        "description": description,
        "description2": description2,
      };
      dynamic response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        var totalAmount = json.decode(response.body);
        return totalAmount;
      } else {
        throw Exception('Failed to fetch transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch stokvel available balance: $e');
    }
  }

  Future<String?> getStokvelTotalRequested() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/getStokvelTotalRequested.php";
      Map<String, String?> body = {
        "description": description,
        "description2": description2,
      };
      dynamic response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        var totalAmount = json.decode(response.body);
        return totalAmount;
      } else {
        throw Exception('Failed to fetch requested: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch stokvel requested total: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.blueGrey,
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blueGrey,
                      child: SizedBox(
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                color: Colors.blueGrey,
                                child: SingleChildScrollView(
                                  child: Flexible(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 25.0),
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                          "images/icon.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 1,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Welcome to",
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          color: Colors.black,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 3.0,
                                                              color:
                                                                  Colors.black,
                                                              offset: Offset(
                                                                  4.0, 4.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return const StokvelInfo();
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: const Flexible(
                                                          child: Text(
                                                            "C_U_Stokvel Savings",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: true,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 26,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              TextButton(
                                                onPressed: () async {},
                                                child: const Icon(
                                                  Icons.refresh,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              PopupMenuButton(
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry>[
                                                  PopupMenuItem(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return const UserStatementScreen();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'My Profile',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Are you sure you want to logout?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                    'No',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                    'Yes',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const LoginScreen(),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Logout',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ),
                                                ],
                                                icon:
                                                    const Icon(Icons.more_vert),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    FutureBuilder<String?>(
                                                      future:
                                                          getStokvelTotalContributions(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<String?>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircularProgressIndicator();
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              const Text(
                                                                'Stokvel Balance',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                "E ${snapshot.data ?? '0'}.00",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  children: [
                                                    FutureBuilder<String?>(
                                                      future:
                                                          getStokvelTotalRequested(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<String?>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircularProgressIndicator();
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              const Text(
                                                                'Requested',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                "E ${snapshot.data ?? '0'}.00",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
