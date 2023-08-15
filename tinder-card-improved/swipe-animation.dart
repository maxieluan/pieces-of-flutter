import 'package:flutter/material.dart';

void main() {
  runApp(TinderSwipeApp());
}

class TinderSwipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TinderSwipeScreen(),
    );
  }
}

class TinderSwipeScreen extends StatefulWidget {
  @override
  _TinderSwipeScreenState createState() => _TinderSwipeScreenState();
}

enum AnimationType {
  flyout,
  back,
  none,
}

class _TinderSwipeScreenState extends State<TinderSwipeScreen> with TickerProviderStateMixin {
  List<String> profiles = [
    "Profile 1",
    "Profile 2",
    "Profile 3",
    // Add more profiles here...
  ];
  int currentIndex = 0;

  bool moving = false;
  AnimationType animationType = AnimationType.none;
  double startDX = 0.0;
  double cardOffset = 0.0;
  double tilt = 0.0;

  late AnimationController _returnController;
  late AnimationController _flyOutController;
  late AnimationController _dummyController;
  late Animation<Offset> _flyOutAnimation;
  late Animation<Offset> _returnAnimation;

  @override
  void initState() {
    super.initState();
    _returnController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _flyOutController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _dummyController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    _flyOutController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          currentIndex++;
          if (currentIndex >= profiles.length) {
            currentIndex = 0;
          }
          tilt = 0.0;
          cardOffset = 0.0;
          animationType = AnimationType.none;
        });
        _flyOutController.reset();

      }
    });

    _returnController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          tilt = 0.0;
          cardOffset = 0.0;
          animationType = AnimationType.none;
        });
        _returnController.reset();
      }
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      moving = true;
      startDX = details.localPosition.dx;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      double dx = details.localPosition.dx;
      cardOffset = dx - startDX;
      tilt = (cardOffset / 300).clamp(-1.0, 1.0); // Adjust the tilt based on the cardOffset
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      moving = false;
      if (cardOffset.abs() > 100) {
        // Swipe card off the screen
        animationType = AnimationType.flyout;
        _flyOutAnimation = Tween<Offset>(
          begin: Offset(cardOffset, 0),
          end: Offset(cardOffset.sign * 400, 0),
        ).animate(_flyOutController);
        _flyOutController.forward();
      } else {
        animationType = AnimationType.back;
        _returnAnimation = Tween<Offset>(
          begin: Offset(cardOffset, 0),
          end: Offset(0, 0),
        ).animate(_returnController);
        _returnController.forward(from: cardOffset.abs() / 100);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tinder Swipe Effect'),
      ),
      body: Stack(
        children: [
          // Background card
          Positioned(
            top: 80,
            height: 400,
            left: 8,
            right: 8,
            child: Card(
              elevation: 4,
              child: Center(
                child: Text(profiles[(currentIndex + 1) % profiles.length]),
              ),
            ),
          ),
          // Front card
          Positioned(
            top: 80,
            height:400,
            left: 8,
            right: 8,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedBuilder(
                animation: _dummyController,
                builder: (context, child) {
                  switch (animationType) {
                    case AnimationType.back:
                      return AnimatedBuilder(animation: _returnController, builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_returnController.value, 0),
                          child: Transform.rotate(
                            angle: (_returnController.value / 300).clamp(-1.0, 1.0),
                            child: Card(
                              elevation: 8,
                              child: Center(
                                child: Text(profiles[currentIndex]),
                              ),
                            ),
                          ),
                        );
                      });
                      break;
                    case AnimationType.flyout:
                      return AnimatedBuilder(animation: _flyOutController, builder: (context, child) {
                        return Transform.translate(
                          offset: _flyOutAnimation.value,
                          child: Transform.rotate(
                            angle: tilt,
                            child: Card(
                              elevation: 8,
                              child: Center(
                                child: Text(profiles[currentIndex]),
                              ),
                            ),
                          ),
                        );
                      });
                      break;
                    case AnimationType.none:
                      return Transform.translate(
                        offset: Offset(cardOffset, 0),
                        child: Transform.rotate(
                          angle: tilt,
                          child: Card(
                            elevation: 8,
                            child: Center(
                              child: Text(profiles[currentIndex]),
                            ),
                          ),
                        ),
                      );
                      break;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
