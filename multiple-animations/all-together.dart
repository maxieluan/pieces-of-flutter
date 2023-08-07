import 'package:flutter/material.dart';

void main() {
  runApp(SquareAnimationApp());
}

class SquareAnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SquareAnimationScreen(),
    );
  }
}

class SquareAnimationScreen extends StatefulWidget {
  @override
  _SquareAnimationScreenState createState() => _SquareAnimationScreenState();
}

class _SquareAnimationScreenState extends State<SquareAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _bouncingController;
  late Animation<double> _bouncingAnimation;

  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _bouncingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _bouncingController.reverse();
      }
    });

    _colorController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _colorController.reverse();
      }
    });

    _sizeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _sizeController.reverse();
      }
    });

    _bouncingAnimation = Tween<double>(begin: 0, end: 100).animate(_bouncingController)
      ..addListener(() {
        setState(() {});
      });

    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.green).animate(_colorController)
      ..addListener(() {
        setState(() {});
      });

    _sizeAnimation = Tween<double>(begin: 100, end: 150).animate(_sizeController)
      ..addListener(() {
        setState(() {});
      });

    _bouncingController.forward();
    _colorController.forward();
    _sizeController.forward();
  }

  @override
  void dispose() {
    _bouncingController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Square Animation'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _bouncingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bouncingAnimation.value),
              child: AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return AnimatedBuilder(
                    animation: _sizeAnimation,
                    builder: (context, child) {
                      return Container(
                        width: _sizeAnimation.value,
                        height: _sizeAnimation.value,
                        color: _colorAnimation.value,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
