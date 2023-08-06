import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Tinder Demo",
        home: TinderSwipeScreen(),
    );
  }
}

class TinderSwipeScreen extends StatefulWidget {
  _TinderSwipeScreenState createState() => _TinderSwipeScreenState();
}

class _TinderSwipeScreenState extends State<TinderSwipeScreen> with SingleTickerProviderStateMixin {
  List<String> profiles = [
    "Profile 1",
    "Profile 2",
    "Profile 3"
  ];

  int currentIndex = 0;
  bool isMoving = false;
  double tilt = 0.0;
  double cardOffset = 0.0;
  double startDx = 0.0;
  
  @override
  void initState() {
    super.initState();
  }

  void _onPandStart(DragStartDetails details) {
    setState(() {
      isMoving = true;
      startDx = details.localPosition.dx;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      double dx = details.localPosition.dx;
      cardOffset = dx - startDx;
      tilt = (cardOffset / 300).clamp(-1.0, 1.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isMoving = false;
      if (cardOffset.abs() > 100) {
        setState(() {
          currentIndex ++;
          if (currentIndex >= profiles.length) {
            currentIndex = 0;
          }
          isMoving = false;
          tilt = 0.0;
          cardOffset = 0.0;
        });
      } else {
        cardOffset = 0.0;
        tilt = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tinder Demo"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            height: 400,
            child: Card(
              elevation: 4,
              child: Center(
                child: Text(profiles[currentIndex]),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 8,
            right: 8,
            height: 400,
            child: GestureDetector(
              onPanStart: _onPandStart,

              onPanUpdate: _onPanUpdate,

              onPanEnd: _onPanEnd,

              child: Transform.translate(
                offset: Offset(cardOffset, 0),
                child: Transform.rotate(angle: tilt, child: Card(
                    elevation: 8,
                    child: Center(
                      child: Text(profiles[(currentIndex + 1) % profiles.length]),
                    )
                )),
              )
            ),
          )
        ],
      ),
    );
  }
}