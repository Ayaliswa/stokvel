import 'package:flutter/material.dart';

class StokvelRegistrationForm extends StatefulWidget {
  const StokvelRegistrationForm({super.key});

  @override
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
    return SingleChildScrollView(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Stokvel Form'),
          centerTitle: true,
        ),
        body: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create your stokvel and become admin',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _stokvelNameController,
                    decoration: InputDecoration(
                      labelText: 'Stokvel Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stokvel name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _sloganController,
                    decoration: InputDecoration(
                      labelText: 'Slogan',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter slogan';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _bankingDetails1Controller,
                    decoration: InputDecoration(
                      labelText: 'Banking Platform Details 1',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter banking platform details';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _bankingDetails2Controller,
                    decoration: InputDecoration(
                      labelText: 'Banking Platform Details 2',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter banking platform details';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _bankingDetails3Controller,
                    decoration: InputDecoration(
                      labelText: 'Banking Platform Details 3',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter banking platform details';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process data
                          }
                        },
                        child: Text('Create'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _stokvelNameController.clear();
                          _sloganController.clear();
                          _bankingDetails1Controller.clear();
                          _bankingDetails2Controller.clear();
                          _bankingDetails3Controller.clear();
                        },
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
