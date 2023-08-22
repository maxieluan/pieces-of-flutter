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
      duration: Duration(seconds: 4)
    )..addListener(() {
      setState(() {

      });
    });

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
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
            animationValue: _animation.value,
          ),
          size: Size(200, 200),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentPathIndex = (_currentPathIndex + 1) % _paths.length;
          });
          _controller.forward();
        },
        child: Icon(Icons.navigate_next),
      ),
    );

  }
}

class DotsPainter extends CustomPainter {
   final Path path;
   final Color color;
   final double animationValue;

  DotsPainter({required this.animationValue, required this.color, required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
        ..color = color.withOpacity(animationValue)
        ..style = PaintingStyle.fill;

    canvas.translate(size.width/2, size.height/2);
    for (double i = 0; i < 360; i += 60) {
      canvas.save();
      canvas.rotate(i*3.14 / 180);
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}