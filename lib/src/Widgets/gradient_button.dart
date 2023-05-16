import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'dart:async';

// GradientButton.dart
typedef FutureBoolCallback = Future<bool> Function();

class GradientButton extends StatefulWidget {
  final FutureBoolCallback? onPress;
  final String? text;

  const GradientButton({Key? key, this.onPress, this.text}) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
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
  late Animation<double> _borderWidthAnimation;
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _borderWidthAnimation = Tween<double>(begin: 0, end: 4.0).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _borderWidthAnimation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        setState((){
          if (_borderColor != gradients[0]) _borderColor = gradients[3];
        });
      },
      onPointerUp: (event){
        setState(() {
          if (_borderColor != gradients[0]) _borderColor = gradients[0];
        });
      },
      child: FutureBuilder<bool>(
        future: null, // Initialize the future to null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return AnimatedBuilder(
            animation: _borderWidthAnimation,
            builder: (BuildContext context, Widget? child) {
              return Container(
                padding: EdgeInsets.all(_borderWidthAnimation.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: _borderColor.colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    width: 2,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => _borderColor = gradients[3]);
                    _rotationController.repeat(); // Start the rotation animation.
                    bool result = await (widget.onPress!());
                    _rotationController.stop(); // Stop the rotation animation.

                    // Show a red border if the result is false, otherwise show a green border. (after 1 second the border goes back to blue)
                    setState(() => _borderColor = result ? gradients[1] : gradients[2]);
                    Future.delayed(const Duration(seconds: 1), () => setState(() => _borderColor = gradients[0]));
                    // Reset the animation
                    _rotationController.animateTo(0, curve: Curves.easeInOut);
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
                  child: Text(widget.text ?? 'Button'),
                )
              );
            }
          );
        },
      ),
    );
  }
}