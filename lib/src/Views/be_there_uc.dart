import 'package:flutter/material.dart';
import 'eat_there_uc.dart';
import '../uc_api.dart' as uc;
import '../Widgets/gradient_button.dart';
import '../Widgets/logout_button.dart';

class Be extends StatefulWidget {
  const Be({Key? key}) : super(key: key);

  @override
  State<Be> createState() => _BeState();
}

class _BeState extends State<Be> with SingleTickerProviderStateMixin {
  Future<bool> _sendPresence() async {
    final token = await uc.getToken(); // check if token is still valid (and return it)
    if (token == '') return false;
    print('token: $token');

    Map<String, String> current = await uc.getAula(token);
    String session = current['session'] ?? '';
    String aula = current['aula'] ?? '';
    if (aula == '' || session == '' || !(await uc.getPresence(token, aula))) return false;
    return !(await uc.submitPresence(token, aula, session) == null);
  }

  Widget eatButton() {
    return IconButton(
      icon: const Icon(Icons.food_bank_rounded),
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Eat()));
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
          eatButton(),
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
            Expanded(
              child: Center(
                child: GradientButton(
                  onPress: _sendPresence,
                  text: 'be'
                ),
              )
            ),
            const Align(
              alignment: FractionalOffset.bottomCenter,
              child: LogoutButton()
            ),
          ],
        ),
      ),
      
    );
  }
}