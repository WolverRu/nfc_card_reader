import 'package:flutter/material.dart';

class PulsatingCircle extends StatefulWidget {
  const PulsatingCircle({super.key});

  @override
  State<PulsatingCircle> createState() => _PulsatingCircleState();
}

class _PulsatingCircleState extends State<PulsatingCircle>
    with TickerProviderStateMixin {
  late AnimationController _circleAnimationController;
  late Animation<double> _circleAnimation;

  late AnimationController _firstCircleBoxShadowController;
  late Animation<double> _firstCircleBoxShadowAnimation;

  late AnimationController _secondCircleBoxShadowController;
  late Animation<double> _secondCircleBoxShadowAnimation;

  @override
  void initState() {
    super.initState();

    _circleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _circleAnimation =
        Tween(begin: 100.0, end: 115.0).animate(_circleAnimationController)
          ..addListener(() {
            setState(() {});
          });

    _firstCircleBoxShadowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _firstCircleBoxShadowAnimation =
        Tween(begin: 0.0, end: 50.0).animate(CurvedAnimation(
      parent: _firstCircleBoxShadowController,
      curve: Curves.easeInOut,
    ));

    _secondCircleBoxShadowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _secondCircleBoxShadowAnimation = Tween(begin: 25.0, end: 50.0).animate(
        CurvedAnimation(
            parent: _secondCircleBoxShadowController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _circleAnimationController.dispose();
    _firstCircleBoxShadowController.dispose();
    _secondCircleBoxShadowController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: _circleAnimation.value,
      height: _circleAnimation.value,
      decoration: BoxDecoration(
        boxShadow: [
          for (int i = 1; i <= 2; i++)
            BoxShadow(
              color: const Color.fromRGBO(68, 143, 255, 0.5)
                  .withOpacity(_circleAnimationController.value / 2),
              spreadRadius: i == 1
                  ? _firstCircleBoxShadowAnimation.value
                  : _secondCircleBoxShadowAnimation.value,
            )
        ],
        shape: BoxShape.circle,
        color: const Color.fromRGBO(68, 143, 255, 0.808),
        // Color.fromRGBO(255, 68, 99, 50)
      ),
      child: const Stack(
        children: [
          Center(
            child: Icon(
              Icons.nfc,
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
