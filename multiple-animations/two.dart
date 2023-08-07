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
  late AnimationController _horizontalController;
  late AnimationController _verticalController;
  late Animation<double> _horizontalAnimation;
  late Animation<double> _verticalAnimation;

  bool _horizontalMode = true;

  @override
  void initState() {
    super.initState();

    _horizontalController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _horizontalController.reverse();
      }
    });

    _verticalController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _verticalController.reverse();
      }
    });

    _horizontalAnimation = Tween<double>(begin: 0, end: 200).animate(_horizontalController)
      ..addListener(() {
        setState(() {});
      });

    _verticalAnimation = Tween<double>(begin: 0, end: 200).animate(_verticalController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  void _toggleAnimationMode() {
    setState(() {
      _horizontalMode = !_horizontalMode;
      if (_horizontalMode) {
        _verticalController.stop();
        _horizontalController.reset();
        _horizontalController.forward();
      } else {
        _horizontalController.stop();
        _verticalController.reset();
        _verticalController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Square Animation'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _horizontalMode ? _horizontalAnimation : _verticalAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                _horizontalMode ? _horizontalAnimation.value : 0,
                _horizontalMode ? 0 : _verticalAnimation.value,
              ),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAnimationMode,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
