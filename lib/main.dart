import "package:flutter/material.dart";
import 'package:stokvel/registration/sign_up_screen.dart';
import 'package:stokvel/security/login_screen.dart';

void main() {
  runApp(const Stokvel());
}

class Stokvel extends StatelessWidget {
  const Stokvel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Stokvel Main Screen",
      home: Stack(
        children: <Widget>[
          Image.asset(
            "images/background3.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Center(
                child: Text('Failed to load image'),
              );
            },
          ),
          const MainWelcomeScreen(),
        ],
      ),
    );
  }
}

class MainWelcomeScreen extends StatelessWidget {
  const MainWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SizedBox(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  "Hello,",
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: Text(
                    "Welcome to City United Stokvel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 300.0,
                  //height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text("LOGIN"),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 200.0,
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 300.0,
                  //height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text("REGISTER"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
1. Fetching Transactions:

Future<List<Transaction>> fetchTransactions() async {
  // ... Your code to fetch transactions from the server
  // (e.g., using http package to make an API call)

  // Assuming your server response provides a list of transaction objects
  final response = await http.get(Uri.parse('your_api_endpoint'));
  final data = json.decode(response.body) as List;
  return data.map((item) => Transaction.fromJson(item)).toList();
}



2. Creating a Transaction Class:

class Transaction {
  final double amount;
  final DateTime timestamp; // Optional, depending on your needs

  Transaction(this.amount, this.timestamp);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(json['amount'] as double, DateTime.parse(json['timestamp'])); // Adjust property names based on your server response
  }
}



3. Calculating Total Amount:

@override
Widget build(BuildContext context) {
  // ... (existing code)

  FutureBuilder<List<Transaction>>(
    future: fetchTransactions(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      final transactions = snapshot.data!;
      double totalAmount = transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);

      return Scaffold(
        // ... (rest of your code)

        Column(
          children: [
            Text(
              'Available Bal',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),
            Text(
              'E ${totalAmount.toStringAsFixed(2)}', // Format to 2 decimal places
              style: TextStyle(fontSize: 20),
            ),
            // ... (rest of your column)
          ],
        ),
      );
    },
  );

  // ... (rest of your code)
}
*/