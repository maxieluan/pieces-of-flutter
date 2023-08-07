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

enum AnimationType {
  bouncing,
  changingColor,
  growingShrinking,
}

class _SquareAnimationScreenState extends State<SquareAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _bouncingController;
  late Animation<double> _bouncingAnimation;

  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  AnimationType _activeAnimation = AnimationType.bouncing;

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

  void _startAnimation(AnimationType animationType) {
    setState(() {
      _activeAnimation = animationType;
    });

    switch (animationType) {
      case AnimationType.bouncing:
        _bouncingController.forward();
        break;
      case AnimationType.changingColor:
        _colorController.forward();
        break;
      case AnimationType.growingShrinking:
        _sizeController.forward();
        break;
    }
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
                  switch(_activeAnimation) {
                    case AnimationType.bouncing:
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue
                      );
                    case AnimationType.changingColor:
                      return Container(
                        width: 100,
                        height:100,
                        color: _colorAnimation.value,
                      );
                    case AnimationType.growingShrinking:
                      return Container(
                        width: _sizeAnimation.value,
                        height: _sizeAnimation.value,
                        color: Colors.blue
                      );
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _startAnimation(AnimationType.bouncing),
            child: Icon(Icons.bubble_chart)
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _startAnimation(AnimationType.changingColor),
            child: Icon(Icons.color_lens),
          ),
          SizedBox(height:10),
          FloatingActionButton(
            onPressed: () => _startAnimation(AnimationType.growingShrinking),
            child: Icon(Icons.aspect_ratio),
          )
        ],
      ),
    );
  }
}
