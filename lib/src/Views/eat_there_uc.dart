import 'package:awesome_project/src/Views/be_there_uc.dart';
import 'package:awesome_project/src/Widgets/logout_button.dart';
import 'package:flutter/material.dart';
import '../Widgets/gradient_button.dart';

class Eat extends StatefulWidget {
  const Eat({Key? key}) : super(key: key);

  @override
  State<Eat> createState() => _EatState();
}

class _EatState extends State<Eat> with SingleTickerProviderStateMixin {
  Widget beButton() {
    return IconButton(
      icon: const Icon(Icons.school_rounded),
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Be()));
      },
      tooltip: 'Presences',
    );
  }

  Future<bool> _buyMeal() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('eatThereUC', style: TextStyle(fontFamily: 'Comfortaa')),
        actions: <Widget>[
          beButton(),
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Comprar Refeição',
              style: TextStyle(fontSize: 30, fontFamily: 'Comfortaa', color: Colors.white),
            ),
            Expanded(
              child: Center(
                child: GradientButton(
                  onPress: _buyMeal,
                  text: 'eat'
                ),
              )
            ),
            const Align(
              alignment: FractionalOffset.bottomCenter,
              child: LogoutButton(),
            ),
          ],
        ),
      ),
      
    );
  }
}