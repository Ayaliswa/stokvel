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
  final _stokvelNameController = TextEditingController();
  final _sloganController = TextEditingController();
  final _bankingDetails1Controller = TextEditingController();
  final _bankingDetails2Controller = TextEditingController();
  final _bankingDetails3Controller = TextEditingController();

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
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _stokvelNameController,
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
                        if (value == null || value.isEmpty) {
                          return 'Please enter stokvel name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _sloganController,
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
                        if (value == null || value.isEmpty) {
                          return 'Please enter slogan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Add Stokvel Commercial Banking Details',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bankingDetails1Controller,
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
                        if (value == null || value.isEmpty) {
                          return 'Please enter banking platform details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Add Stokvel MOMO Banking Details',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bankingDetails2Controller,
                      decoration: const InputDecoration(
                        hintText: 'name of account holder',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Account Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.account_circle, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter banking platform details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Add Stokvel e-Mali Banking Details',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _bankingDetails3Controller,
                      decoration: const InputDecoration(
                        hintText: 'name of account holder ',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        labelText: 'Account Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                            Icon(Icons.account_circle, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter banking platform details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
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
                          child: const Text('CREATE STOKVEL'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _stokvelNameController.clear();
                            _sloganController.clear();
                            _bankingDetails1Controller.clear();
                            _bankingDetails2Controller.clear();
                            _bankingDetails3Controller.clear();
                          },
                          child: const Text('CLEAR FORM'),
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
