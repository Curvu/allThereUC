import 'package:flutter/material.dart';
import 'src/Views/login.dart';
import 'src/Views/be_there_uc.dart';
import 'src/uc_api.dart' as api;
import 'src/plugins/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // get the correct page to show
  Widget getPage() {
    return FutureBuilder<String>(
      future: api.getToken(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data != '' ? const Be() : const Login();
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