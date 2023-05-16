import 'package:flutter/material.dart';
import 'dart:async';
import '../Views/login.dart';
import '../storage.dart' as storage;

// GradientButton.dart
typedef FutureBoolCallback = Future<bool> Function();

class LogoutButton extends StatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 300,
        height: 50,
        child: TextButton(
          onPressed: () {
            storage.clear();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa'),
          ),
          child: const Text('Logout'),
        )
      )
    );
  }
}