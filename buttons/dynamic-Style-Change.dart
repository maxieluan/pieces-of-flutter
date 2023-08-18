import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: FloatingButtonPage()
    );
  }
}

class FloatingButtonPage extends StatefulWidget {
  const FloatingButtonPage({super.key});

  @override
  _FloatingButtonPageState createState() => _FloatingButtonPageState();
}

class CustomFABStyle {
  late final Color backgroundColor;
  late final Color foregroundColor;
  late final ShapeBorder shapeBorder;
  late final double elevation;
  late final Color splashColor;
  late final Color hoverColor;
  late final Color focusColor;

  CustomFABStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.shapeBorder,
    required this.elevation,
    required this.splashColor,
    required this.hoverColor,
    required this.focusColor
  });
}

class _FloatingButtonPageState extends State<FloatingButtonPage> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isVisible = false;
  late AnimationController _animationController;
  final Duration _duration = const Duration(milliseconds: 100);
  late Animation<double> buttonOffsetAnimation;

  Map<String, CustomFABStyle> styles = {
    "Default": CustomFABStyle(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shapeBorder: CircleBorder(),
      elevation: 6.0,
      splashColor: Colors.blueAccent,
      hoverColor: Colors.blue[800]!,
      focusColor: Colors.blue[800]!
    ),
    "Red": CustomFABStyle(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      splashColor: Colors.redAccent,
      hoverColor: Colors.red[800]!,
      focusColor: Colors.red[800]!,
    ),
  };
  late CustomFABStyle selectedStyle;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _duration)..addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        print("completed, with state: ${_isExpanded}");
        if (_isExpanded == false) {
          setState(() {
            _isVisible = false;
          });
        }
      }

      if (status == AnimationStatus.forward) {
        print("started, with state: ${_isExpanded}");
        if (_isExpanded == true) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
    buttonOffsetAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(_animationController);
    selectedStyle = styles["Default"]!;
  }

  @override
  Widget build(BuildContext context) {
    List<TextButton> list = [];
    styles.forEach((key, value) {
      list.add(TextButton(onPressed: (){
        setState(() {
          selectedStyle = value;
        });
      }, child: Text(key)));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Floating Action Button Menu"),
      ),
      body: Center(
          child: Column(
            children: list
          ),
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context){
    List<Widget> list = _buildSecondaryButtons();
      return Stack(
        children: [
          ...list,
          Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                  onPressed: (){
                    if (_isExpanded == true) {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        _animationController.reverse();
                      });
                    } else {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        _animationController.forward();
                      });
                    }
                  },
                  tooltip: _isExpanded? "Close Menu" : "Open Menu",
                  child: Icon(_isExpanded ? Icons.close: Icons.add)
              )
          )
        ],
      );

  }

  List<Widget> _buildSecondaryButtons() {
    if (_isVisible) {
      return [
        _buildSecondaryButton(Icons.camera, 1),
        _buildSecondaryButton(Icons.photo, 2),
        _buildSecondaryButton(Icons.video_call, 3)
      ];
    } else {
      return [];
    }
  }

  Widget _buildSecondaryButton(IconData iconData, double bottom) {
    return AnimatedBuilder(animation: _animationController, builder: (BuildContext context, Widget? child)
    {
      return Positioned(
        right: 16.0,
        bottom: buttonOffsetAnimation.value * bottom + 16,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: selectedStyle.backgroundColor,
          foregroundColor: selectedStyle.foregroundColor,
          shape: selectedStyle.shapeBorder,
          elevation: selectedStyle.elevation,
          splashColor: selectedStyle.splashColor,
          hoverColor: selectedStyle.hoverColor,
          focusColor: selectedStyle.focusColor,
          child: Icon(iconData),
        )
      );
    });
  }
}

