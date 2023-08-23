import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedDots(),
    );
  }
}

class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dotPosition = 0.0;
  // Define paths for the shapes
  final List<Path> _paths = [
    Path()..addOval(Rect.fromCircle(center: Offset(0, 0), radius: 20)),
    Path()
      ..addRect(Rect.fromPoints(Offset(-20, -20), Offset(20, 20))),
    Path()
      ..moveTo(0, -20)
      ..lineTo(20, 10)
      ..lineTo(10, 20)
      ..lineTo(-10, 20)
      ..lineTo(-20, 10)
      ..close(),
  ];

  final List<Color> _colors = [Colors.red, Colors.blue, Colors.yellow];
  int _currentPathIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,
      duration: Duration(milliseconds: 2000)
    )..addListener(() {
      setState(() {
        _dotPosition = _animation.value;
      });
    });

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Dots")
      ),

      body: Center(
        child: CustomPaint(
          painter: DotsPainter(
            path: _paths[_currentPathIndex],
            color: _colors[_currentPathIndex],
            dotPosition: _dotPosition,
          ),
          size: Size(200, 200),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentPathIndex = (_currentPathIndex + 1) % _paths.length;
          });
        },
        child: Icon(Icons.navigate_next),
      ),
    );

  }
}

class DotsPainter extends CustomPainter {
   final Path path;
   final Color color;
   final double dotPosition;
  DotsPainter({required this.dotPosition, required this.color, required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke;

    final Paint dot = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

    final PathMetrics metrics = path.computeMetrics();
    final PathMetric metric = metrics.elementAt(0);
    final Tangent? tangent = metric.getTangentForOffset(metric.length * dotPosition);
    final Offset? dotOffset = tangent?.position;

    canvas.translate(size.width/2, size.height/2);
    canvas.drawPath(path, paint);
    canvas.drawCircle(dotOffset!, 5, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}