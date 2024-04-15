import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/stokvel/request.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/header/stokvel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  int selectedItem = 1;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => const StokvelStatementScreen()),
      );
    }
    if (index == 1) {}
    if (index == 2) {
      Navigator.push(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => const PendingRequestScreen()),
      );
    }
  }

  final List<Message> messages = [];
  final TextEditingController messageController = TextEditingController();

  Future<void> sendMessage() async {
    try {
      if (messageController.text.isNotEmpty) {
        String? username = await getUsername();
        String? phone = await getPhoneByUsername();
        String url = "http://127.0.0.1/stokvel_api/saveMessages.php";
        dynamic response = await http.post(
          Uri.parse(url),
          body: {
            'phone': phone,
            'text': messageController.text,
            'isMine': '1',
            'timestamp': DateTime.now().toIso8601String(),
            'username': username,
          },
        );
        if (response.statusCode == 200) {
          messageController.clear();
          setState(() {});
        } else {
          throw Exception('Failed to send message');
        }
      }
    } catch (e) {
      throw Exception("??Database connection failed");
    }
  }

/*Future<List<Message>> displayMessages() async {
  try {
    String url = "http://127.0.0.1/stokvel_api/displayMessages.php"; // Assuming separate endpoint
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) { // Check for success (adjust based on server response)
        List<dynamic> data = responseData['messages']; // Assuming messages are in a nested key
        List<Message> messages = data
            .map((item) => Message(
                item['text'],
                item['isMine'] == '1',
                item['username'],
                DateTime.parse(item['timestamp']),
            ))
            .toList();
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return messages;
      } else {
        // Handle empty messages case (check for 'no_messages' key in response)
        if (responseData['error'] == 'no_messages') {
          return []; // Return empty list
        } else {
          throw Exception('Failed to load messages: ${responseData['error']}'); // More specific error
        }
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error getting messages: $e');
    throw Exception('Failed to load messages'); // Consider more user-friendly message
  }
}
*/

  Future<List<Message>> fetchStokvelMessages() async {
    try {
      String url = "http://127.0.0.1/stokvel_api/fetchStokvelMessages.php";
      dynamic response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        List<dynamic> dataList = data as List;
        List<Message> messages = dataList
            .map((item) => Message(
                  item['Text'],
                  item['isMine'] == '1',
                  item['Username'],
                  DateTime.parse(item['Timestamp']),
                ))
            .toList();
        // Sort the messages by timestamp in ascending order
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return messages;
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      throw ("No Chats to display");
    }
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Future<String?> getPhoneByUsername() async {
    try {
      String username = await getUsername();
      print(username);
      print('get one');
      String url =
          "http://127.0.0.1/stokvel_api/getPhoneByUsername.php?username=$username";
      print('get two');
      Map<String, String> body = {"username": username};
      dynamic response = await http.post(Uri.parse(url), body: body);
      print('get three');

      print('get four');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        print(response.body);
        print('get five');
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
              Expanded(
                child: FutureBuilder<List<Message>>(
                  future: fetchStokvelMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    final messages = snapshot.data!;
                    return ListView.builder(
                      reverse: false,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMine = message.isMine;
                        return Container(
                          alignment: isMine
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: messages[index].isMine
                                  ? Colors.grey
                                  : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              messages[index].text,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                child: Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          sendMessage();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Message {
  final String text;
  final bool isMine;
  final String phoneNumber;
  final DateTime timestamp;

  Message(this.text, this.isMine, this.phoneNumber, this.timestamp);
}
