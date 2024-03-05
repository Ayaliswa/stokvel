import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:stokvel/bottom_navigation_bar/stokvel_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/stokvel/request.dart';
import 'package:stokvel/bottom_tabs/stokvel/statement.dart';
import 'package:stokvel/header/stokvel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart';

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
  final TextEditingController controller = TextEditingController();
  late Database db;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'messages.db');
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Messages (id INTEGER PRIMARY KEY, text TEXT, isMine BOOLEAN, timestamp TEXT, phoneNumber TEXT, FOREIGN KEY(phoneNumber) REFERENCES login(phone))');
  }

  void sendMessage() async {
    if (controller.text.isNotEmpty) {
      await db.insert('Messages', {
        'text': controller.text,
        'isMine': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
      controller.clear();
      setState(() {});
    }
  }

  Future<List<Message>> getMessages() async {
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT Messages.*, login.phone 
    FROM Messages 
    INNER JOIN login ON Messages.phoneNumber = login.phone
    ORDER BY Messages.timestamp DESC
  ''');

    return List.generate(maps.length, (i) {
      return Message(
        maps[i]['text'],
        maps[i]['isMine'] == 1,
        maps[i]['phone'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StokvelNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: Column(
        children: <Widget>[
          const StokvelHeader(),
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error.toString()}'));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: messages[index].isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: messages[index].isMine
                              ? Colors.blue
                              : Colors.grey,
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
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMine;
  final String phoneNumber;

  Message(this.text, this.isMine, this.phoneNumber);
}
