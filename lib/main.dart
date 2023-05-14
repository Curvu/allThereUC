import 'package:flutter/material.dart';
import 'src/Views/login.dart';
import 'src/Views/be_there_uc.dart';
import 'src/api_functions.dart' as api;
import 'package:localstorage/localstorage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // try to login with stored email and password
  Future<String> checkCredentials() async {
    final LocalStorage storage = LocalStorage('allThereUC');
    await storage.ready;
    String? email = await storage.getItem('email');
    String? password = await storage.getItem('password');
    if (email != null && password != null) {
      return await api.tryLogin(email, password);
    } else {
      return '';
    }
  }

  // get the correct page to show
  Widget getPage() {
    return FutureBuilder<String>(
      future: checkCredentials(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data != '' ? Be(token: snapshot.data) : const Login();
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