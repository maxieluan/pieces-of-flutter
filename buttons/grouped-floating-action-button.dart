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

class _FloatingButtonPageState extends State<FloatingButtonPage> {
  bool _isExpanded = false;

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
                setState((){
                  _isExpanded = !_isExpanded;
                });
              },
              tooltip: _isExpanded? "Close Menu" : "Open Menu",
              child: Icon(_isExpanded ? Icons.close: Icons.add)
          )
        )
      ],
    );
  }

  List<Widget> _buildSecondaryButtons() {
    if (_isExpanded) {
      return [
        _buildSecondaryButton(Icons.camera, 80),
        _buildSecondaryButton(Icons.photo, 140),
        _buildSecondaryButton(Icons.video_call, 200)
      ];
    } else {
      return [];
    }
  }

  Widget _buildSecondaryButton(IconData iconData, double bottom) {
    print (bottom);
    return Positioned(
      right: 16.0,
      bottom: bottom,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded? 56: 0.0,
        width: _isExpanded? 56: 0.0,
        child: FloatingActionButton(
          onPressed: (){},
          child: Icon(iconData),
        )
      ),
    );
  }
}

