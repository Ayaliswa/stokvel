/*import 'package:flutter/material.dart';

class StokvelInfo extends StatefulWidget {
  const StokvelInfo({super.key});

  @override
  _StokvelInfoState createState() => _StokvelInfoState();
}

class _StokvelInfoState extends State<StokvelInfo> {
  String _groupName = 'Group Name';
  String _groupSlogan = 'Group Slogan';
  String _groupPhotoPath = 'assets/images/group_photo.png';
  List<String> _members = ['Member 1', 'Member 2', 'Member 3'];

  void _updateGroupPhoto() async {
    // TODO: Implement updating group photo from user's files.
  }

  void _addMembers() async {
    // TODO: Implement adding members to the group.
  }

  void _viewAllMembers() async {
    // TODO: Implement displaying all members of the group.
  }

  void _exitGroup() async {
    // TODO: Implement exiting the group.
  }

  void _reportAbuse() async {
    // TODO: Implement reporting abuse in the group.
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
        title: const Text("Stokvel Information"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Add members',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Change Stokvel name',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: _updateGroupPhoto,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_groupPhotoPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _groupName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _groupSlogan,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addMembers,
            child: const Text('Add Members'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _viewAllMembers,
            child: Text(
              'View All Members (${_members.length})',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _exitGroup,
            child: const Text('Exit Group'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _reportAbuse,
            child: const Text('Report Abuse'),
          ),
        ],
      ),
    );
  }
}
*/

import "package:flutter/material.dart";
import "package:stokvel/login_screen.dart";

class StokvelInfo extends StatefulWidget {
  const StokvelInfo({super.key});

  @override
  State<StokvelInfo> createState() => _StokvelInfoState();
}

class _StokvelInfoState extends State<StokvelInfo> {
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
        title: const Text("Stokvel Information"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Add members',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Change Stokvel name',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              decoration: const BoxDecoration(color: Colors.grey),
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                width: 400,
                child: SingleChildScrollView(
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
                      const SizedBox(width: 20),
                      const Text(
                        'City United Stokvel',
                        //maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '33 members',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "View All Members",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Add members",
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    'Are you sure you want to leave the stokvel?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'You are no longer part of the stokvel'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return const LoginScreen();
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Exit Stokvel",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
