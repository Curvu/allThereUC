import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'login.dart';
import '../api_functions.dart' as api;

class Home extends StatefulWidget {
  final String? token;

  const Home({Key? key, this.token}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? getToken() => widget.token;
  Color _borderColor = const Color(0xFF1E90FF);

  Widget logoutButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 300,
        height: 50,
        child: TextButton(
          onPressed: () {
            final LocalStorage storage = LocalStorage('allThereUC');
            storage.deleteItem('email');
            storage.deleteItem('password');
            Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => const Login()));
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa'),
            // padding bottom 10
          ),
          child: const Text('Logout'),
        )
      )
    );
  }

  Widget presenceButton() {
    return Listener(
      onPointerDown: (event) => setState(() => _borderColor = const Color(0xFFFFFFFF)),
      onPointerUp: (event) => setState(() => _borderColor = const Color(0xFF1E90FF)),
      child: ElevatedButton(
        onPressed: () async {
          String? token = getToken();
          if (token != null) {
            Map<String, String> current = await api.getAula(token);
            String session = current['session'] ?? '';
            String aula = current['aula'] ?? '';
            if (aula != '' && session != '') {
              bool presence = await api.getPresence(token, aula);
              if (!presence) {
                if (await api.submitPresence(token, aula, session) == null) {
                  setState(() => _borderColor = const Color(0xFFFF0000));
                } else {
                  setState(() => _borderColor = const Color(0xFF00FF00));
                }
              } else {
                setState(() => _borderColor = const Color(0xFFFF0000));
              }
            } else {
              // border color red (0xFFFF0000)
              setState(() => _borderColor = const Color(0xFFFF0000));
            }
            Future.delayed(const Duration(seconds: 1), () => setState(() => _borderColor = const Color(0xFF1E90FF)));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1b1b1b),
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          shape: CircleBorder(
            side: BorderSide(
              color: _borderColor,
              width: 4.0,
              style: BorderStyle.solid,
            ),
          ),
          padding: const EdgeInsets.all(100),
          textStyle: const TextStyle(fontSize: 48, fontFamily: 'Comfortaa'),
        ),
        child: const Text('Click'),
      )
    );
  }

  Widget foodButton() {
    return IconButton(
      icon: const Icon(Icons.school_rounded), // rice_bowl_rounded
      onPressed: () {
        // change to the food page
      },
      tooltip: 'Meals',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('beThereUC', style: TextStyle(fontFamily: 'Comfortaa')),
        actions: <Widget>[
          foodButton(),
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Marcar Presença',
              style: TextStyle(fontSize: 30, fontFamily: 'Comfortaa', color: Colors.white),
            ),
            Expanded(child: Center(
              child: presenceButton(),
            )),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: logoutButton(),
            ),
          ],
        ),
      ),
      
    );
  }
}