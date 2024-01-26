import 'package:flutter/material.dart';
import 'stokvel_profile_screen.dart';

class StokvelRegistrationForm extends StatefulWidget {
  const StokvelRegistrationForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StokvelRegistrationFormState createState() =>
      _StokvelRegistrationFormState();
}

class _StokvelRegistrationFormState extends State<StokvelRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _stokvelName = TextEditingController();
  final _slogan = TextEditingController();
  final _bankName = TextEditingController();
  final _bankAccountNumber = TextEditingController();
  final _momoAccountName = TextEditingController();
  final _momoAccountNumber = TextEditingController();
  final _eMaliAccountName = TextEditingController();
  final _eMaliAccountNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Stokvel'),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'STOKVEL CREATION FORM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
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
                    Image.asset(
                      "images/icon.png",
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    const Text(
                      'Create your stokvel and become admin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _stokvelName,
                      decoration: const InputDecoration(
                        hintText: 'e.g My Stokvel',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Stokvel Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.group, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter stokvel name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _slogan,
                      decoration: const InputDecoration(
                        hintText: 'saving to change our lives',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Slogan/Vision',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.text_format, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your stokvel vision statement';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _slogan,
                      decoration: const InputDecoration(
                        hintText: 'create stokvel 5 digit pin',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Stokvel Pin',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.text_format, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please create pin for your stokvel';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Commercial Banking:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bankName,
                      decoration: const InputDecoration(
                        hintText: 'e.g FNB / Standard Bank / Nedbank ...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Bank Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.account_balance, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter bank name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bankAccountNumber,
                      decoration: const InputDecoration(
                        hintText: 'enter account number',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Account Number',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.numbers, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter bank account number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bankName,
                      decoration: const InputDecoration(
                        hintText: 'e.g Mbabane Corporate Place',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Branch Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.place, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter bank branch name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bankName,
                      decoration: const InputDecoration(
                        hintText: 'enter branch code',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Branch Code',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.code, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter branch code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MOMO Banking:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _momoAccountNumber,
                      decoration: const InputDecoration(
                        hintText: '+268 76...... / 78......',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Account Number',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.numbers, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter MOMO banking account number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _momoAccountName,
                      decoration: const InputDecoration(
                        hintText: 'name of account holder',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Account Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.supervisor_account, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter MOMO banking account name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'e-Mali Banking:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _eMaliAccountNumber,
                      decoration: const InputDecoration(
                        hintText: '+268 79.......',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Account Number',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon: Icon(Icons.numbers, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter eMali banking account number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _eMaliAccountName,
                      decoration: const InputDecoration(
                        hintText: 'name of account holder',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Account Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.supervisor_account, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter eMali banking account name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 400.0,
                          height: 48,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Processing Data...'),
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const StokvelProfileScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                            child: const Text('CREATE STOKVEL'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 400.0,
                          height: 48,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              _stokvelName.clear();
                              _slogan.clear();
                              _bankName.clear();
                              _bankAccountNumber.clear();
                              _momoAccountName.clear();
                              _momoAccountName.clear();
                              _eMaliAccountNumber.clear();
                              _eMaliAccountName.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text('CLEAR FORM'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
