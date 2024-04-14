import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StokvelMemberInfo extends StatefulWidget {
  const StokvelMemberInfo({super.key});

  @override
  State<StokvelMemberInfo> createState() => StokvelMemberInfoState();
}

class StokvelMemberInfoState extends State<StokvelMemberInfo> {
  Future<List<dynamic>> fetchStokvelMember() async {
    try {
      String? phoneNumber = await getPhoneByUsername();
      String url =
          "http://127.0.0.1/stokvel_api/fetchStokvelMember.php?phoneNumber=$phoneNumber";

      Map<String, String?> body = {"phoneNumber": phoneNumber};
      dynamic response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        var membersData = json.decode(response.body);
        return membersData;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to fetch transactions: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchStokvelTransactions: $e');
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
        print(response.body);
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            return data; // Return the phone number as a string
          } else {
            print('Empty phone number received');
            return null;
          }
        } else {
          // ... handle other status codes
        }
      } else {
        print('Error fetching phone: ${response.statusCode}');
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in getPhoneByUsername: $e');
      rethrow;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile Information"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.blueGrey,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10.0),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'images/icon.png',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Username:",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      FutureBuilder<String>(
                        future: getUsername(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            return Column(
                              children: [
                                Text(
                                  "${snapshot.data}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder<List<dynamic>>(
              future: fetchStokvelMember(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final members = snapshot.data!;
                  return ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: const Text(
                              'Full Name:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                member['First Name'],
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                member['Last Name'],
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: const Text(
                              'ID Card No.:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            member['ID Number'],
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: const Text(
                              'Contact:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            member['Phone Number'],
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: const Text(
                              'Postal Address:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            member['Postal Address'],
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: const Text(
                              'Physical Address:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            member['Physical Address'],
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "No personal data found\nPlease make sure you have registered",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
