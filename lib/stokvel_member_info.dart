import "package:flutter/material.dart";
import "package:stokvel/change_password_screen.dart";

class StokvelMemberInfo extends StatefulWidget {
  const StokvelMemberInfo({super.key});

  @override
  State<StokvelMemberInfo> createState() => _StokvelMemberInfoState();
}

class _StokvelMemberInfoState extends State<StokvelMemberInfo> {
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
        title: const Text("Me"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ChangePasswordScreen();
                        },
                      ),
                    );
                  },
                  child: const Text('Change password',
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
                        'Username',
                        //maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Change pasword",
                          style: TextStyle(color: Colors.black, fontSize: 18),
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
