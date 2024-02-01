import "package:flutter/material.dart";

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}
