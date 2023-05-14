import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:localstorage/localstorage.dart';
import 'login.dart';
import '../api_functions.dart' as api;

class Be extends StatefulWidget {
  final String? token;
  const Be({Key? key, this.token}) : super(key: key);

  @override
  State<Be> createState() => _BeState();
}

class _BeState extends State<Be> with SingleTickerProviderStateMixin {
  String? getToken() => widget.token;

  // gradient border color
  static List<Gradient> gradients = <Gradient>[
    LinearGradient(
      colors: [Colors.lightBlue.shade500, Colors.cyanAccent.shade400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.green.shade300, Colors.green.shade600],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.red.shade500, Colors.red.shade800],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Colors.white70, Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  static Gradient _borderColor = gradients[0];

  late AnimationController _rotationController;
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<bool> _sendPresence() async {
    String? token = getToken();
    if (token != null) {
      Map<String, String> current = await api.getAula(token);
      String session = current['session'] ?? '';
      String aula = current['aula'] ?? '';
      if (aula != '' && session != '') {
        if (!(await api.getPresence(token, aula))) {
          return !(await api.submitPresence(token, aula, session) == null);
        }
      }
    }
    return false;
  }

  Widget presenceButton() {
    return Listener(
      onPointerDown: (event) => setState(() => _borderColor = gradients[3]),
      onPointerUp: (event) => setState(() => _borderColor = gradients[0]),
      child: FutureBuilder<bool>(
        future: null, // Initialize the future to null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // If the future is completed, reset the rotation.
          if (snapshot.connectionState == ConnectionState.done) _rotationController.reset();

          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  colors: _borderColor.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                width: 2
              ),
            ),
            child: ElevatedButton(
              onPressed: () async {
                setState(() => _borderColor = gradients[3]);
                _rotationController.repeat(); // Start the rotation animation.
                bool result = await _sendPresence();
                _rotationController.stop(); // Stop the rotation animation.

                // Show a red border if the result is false, otherwise show a green border. (after 1 second the border goes back to blue)
                setState(() => _borderColor = result ? gradients[1] : gradients[2]);
                Future.delayed(const Duration(seconds: 1), () => setState(() => _borderColor = gradients[0]));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1b1b1b),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                shape: const CircleBorder(
                  eccentricity: 0.0,
                  side: BorderSide(style: BorderStyle.none, width: 0.0),
                ),
                padding: const EdgeInsets.all(75),
                textStyle: const TextStyle(fontSize: 48, fontFamily: 'Comfortaa'),
              ),
              child: RotationTransition(
                turns: _rotationController,
                child: const Text('be'),
              ),
            )
          );
        },
      ),
    );
  }


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
          ),
          child: const Text('Logout'),
        )
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
            Expanded(
              child: Center(
                child: presenceButton()
              )
            ),
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

LinearGradientPainter({required colorSpace, required List<Color> colors}) {
}