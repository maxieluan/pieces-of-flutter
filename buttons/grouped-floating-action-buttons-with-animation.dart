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

class _FloatingButtonPageState extends State<FloatingButtonPage> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isVisible = false;
  late AnimationController _animationController;
  final Duration _duration = const Duration(milliseconds: 100);
  late Animation<double> buttonOffsetAnimation;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Floating Action Button Menu"),
      ),
      body: const Center(
          child: Text("Click to expand.")
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
    return AnimatedBuilder(animation: _animations, builder: (BuildContext context, Widget? child)
    {
      print(_isVisible);
      return Positioned(
        right: 16.0,
        bottom: buttonOffsetAnimation.value * bottom + 16,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(iconData),
        )
      );
    });
  }
}

