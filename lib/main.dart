import 'package:flutter/material.dart';
import 'src/Views/login.dart';
import 'src/Views/be_there_uc.dart';
import 'src/uc_api.dart' as api;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // get the correct page to show
  Widget getPage() {
    return FutureBuilder<bool>(
      future: api.refreshToken(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == true ? const Be() : const Login();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'allThereUC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, background: const Color(0xFF1b1b1b)),
        useMaterial3: true,
      ),
      home: getPage(),
    );
  }
}