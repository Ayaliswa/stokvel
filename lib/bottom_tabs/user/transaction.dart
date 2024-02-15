import 'package:flutter/material.dart';
import 'package:stokvel/bottom_navigation_bar/user_navigation_bar.dart';
import 'package:stokvel/bottom_tabs/user/request.dart';
import 'package:stokvel/bottom_tabs/user/statement.dart';
import 'package:stokvel/header/user.dart';

class UserTransactionScreen extends StatefulWidget {
  const UserTransactionScreen({super.key});

  @override
  State<UserTransactionScreen> createState() => _UserTransactionScreenState();
}

class _UserTransactionScreenState extends State<UserTransactionScreen> {
  int selectedItem = 1;
  int selectedPaymentMethod = 0;
  String? dropdownValue;

  void updateItem(int index) {
    setState(() {
      selectedItem = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserStatementScreen()),
      );
    }
    if (index == 1) {}
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserRequestScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UserNavigationBar(
        currentIndex: selectedItem,
        onTap: updateItem,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserHeader(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.white,
                      child: SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Available Stokvel Accounts",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 0;
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "images/MoMo.jpeg"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 1;
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "images/eMali.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 2;
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image:
                                                  AssetImage("images/Visa.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (selectedPaymentMethod == 0)
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.start,
                                                "Deposit via MoMo account",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'How much do you want to deposit',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: 'Amount',
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter amount';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: '76******',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: 'Phone Number',
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(Icons.phone,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter phone number";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.green),
                                                  ),
                                                  child: const Text('SEND...'),
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  child: const Text('CANCEL'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else if (selectedPaymentMethod == 1)
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.start,
                                                "Deposit via eMali account",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "How much do you want to deposit",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Amount",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter amount";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: "79******",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Phone Number",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(Icons.phone,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter phone number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.green),
                                                  ),
                                                  child: const Text('SEND...'),
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  child: const Text('CANCEL'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else if (selectedPaymentMethod == 2)
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.start,
                                                "Deposit via Credit Card",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Enter amount to deposit",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Amount",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter amount you want to deposit";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Enter card registered name",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Card Holder Name",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(Icons.person,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter your name";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: "Enter Card Number",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                              labelText: "Card Number",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              prefixIcon: Icon(Icons.numbers,
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                              // border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter your card number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text("Card Expiry Date",
                                              textAlign: TextAlign.start),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 20),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: DropdownButton<String>(
                                                    value: dropdownValue,
                                                    hint: const Text('Month'),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue;
                                                      });
                                                    },
                                                    items: <String>[
                                                      '01',
                                                      '02',
                                                      '03',
                                                      '04',
                                                      "05",
                                                      "06",
                                                      "07",
                                                      "08",
                                                      "09",
                                                      "10",
                                                      "11",
                                                      "12"
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Expanded(
                                                  child: DropdownButton<String>(
                                                    value: dropdownValue,
                                                    hint: const Text("Year"),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue;
                                                      });
                                                    },
                                                    items: <String>[
                                                      "2024",
                                                      "2025",
                                                      "2026",
                                                      "2027",
                                                      "2028",
                                                      "2029",
                                                      "2030",
                                                      "2031",
                                                      "2032",
                                                      "2033",
                                                      "2034",
                                                      "2035",
                                                      "2036",
                                                      "2037",
                                                      "2038",
                                                      "2039",
                                                      "2040",
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                if (dropdownValue != null)
                                                  Text(
                                                      'Selected: $dropdownValue'),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.name,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "3 digits next to card number",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16),
                                                    labelText:
                                                        "Card CVV Number",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
                                                    prefixIcon: Icon(
                                                        Icons.numbers,
                                                        color: Colors.black),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter your Card CVV Number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons
                                                    .question_mark_rounded),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.green),
                                                  ),
                                                  child: const Text('NEXT...'),
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  child: const Text('CANCEL'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
