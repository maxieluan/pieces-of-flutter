import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugRepaintRainbowEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme(
                primary: Colors.orange,
                primaryContainer: Colors.orange[700],
                secondary: Colors.green,
                secondaryContainer: Colors.green[700],
                brightness: Brightness.light,
                onPrimary: Colors.white,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onError: Colors.white,
                error: Colors.red,
                background: Colors.grey[200]!,
                surface: Colors.white,
                onBackground: Colors.black
            )
        ),
        title: "My App",
        home: const HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class FirstScreen extends StatelessWidget {
  FirstScreen({super.key});
  final GlobalKey<CustomMeterGraphState> meterGraphKey = GlobalKey<CustomMeterGraphState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: ListView(
          children: [
            _buildListItem(const Text("Item 1"), 1),
            _buildListItem(const Text("Item 2"), 2),
            _buildListItem(const Text("Item 2"), 3),
            _buildListItem(
               Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Header",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet.'
                              'Sed do eiusmod tempor incididunt ut.',
                          style: TextStyle(fontSize: 16)
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                      child: Image.asset("assets/images/brain.png", fit: BoxFit.fill)
                    ),
                  )
                ],
              )
            , 4),
            Card(
              elevation: 1, // You can adjust the elevation as needed
              margin: const EdgeInsets.all(8), // Margin around each card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Adjust the corner radius as needed
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)
                ),
                onTap: () {
                  meterGraphKey.currentState?.resetAnimation();
                },
                child:  CustomMeterGraph(key: meterGraphKey, value: 0.7)

              ),
            )
          ],
        )
    );
  }

  Widget _buildListItem(Widget widget, int index) {
    return Card(
      elevation: 1, // You can adjust the elevation as needed
      margin: const EdgeInsets.all(8), // Margin around each card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Adjust the corner radius as needed
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
        ),
        onTap: () {
          _handleItemClick(index);
        },
        child: Padding(
          padding: const EdgeInsets.all(32.0), // Padding inside the card
          child: widget
        ),
      ),
    );
  }

  void _handleItemClick(int itemText) {
    // Handle the click action for the item here
    if (kDebugMode) {
      print('Clicked on: $itemText');
    }
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Text("Second Screen")
    );
  }
}

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
        backgroundColor: Colors.amber,
        body: Text("Overlay Screen")
    );
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchExpanded = false;
  bool _resultFadeIn = false;
  bool _showOverlayScreen = false;
  late OverlayEntry detectorOverlay;
  late AnimationController controller;
  late AnimationController screenTransition;
  late Animation<double> enlargeAnimation;
  late Animation<double> screenTransitonAnimation;
  late Corner overlayOriginatingCorner;

  static List<Widget> screens = <Widget>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    enlargeAnimation = Tween<double>(begin: 0, end: 100).animate(controller);
    screenTransition = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _showOverlayScreen = false;
        });
      }
    });
    screenTransitonAnimation = Tween<double>(begin: 0, end: 1).animate(screenTransition);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _unfocusInput() {
    // Unfocus the text field when tapped outside
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    screens.add(FirstScreen());
    screens.add(const SecondScreen());

    return Stack(
        children: [
          Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(80.0),
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child){
                      return SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    if (hasFocus) {
                                      setState(() {
                                        _isSearchExpanded = true;
                                        controller.forward();
                                      });
                                      Future.delayed(const Duration(milliseconds: 10), (){
                                        setState(() {
                                          _resultFadeIn = true;
                                        });
                                      });
                                    } else {
                                      setState(() {
                                        controller.reverse();
                                        _resultFadeIn = false;

                                        _isSearchExpanded = false;
                                      });
                                    }
                                  },
                                  child: RepaintBoundary(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(16.0 - 16*controller.value, 16 - 16*controller.value, 16 - 16*controller.value, 16),
                                      child: Container(
                                          height: 64+ 32 *controller.value,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0), // Adjust the corner radius as needed
                                            color: Colors.grey[200], // Adjust the background color as needed
                                          ),
                                          child: Stack(
                                            children: [
                                              TextField(
                                                focusNode: _searchFocusNode,
                                                decoration: InputDecoration(
                                                  hintText: 'Search',
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.fromLTRB(64.0, 12.0 + 8*controller.value, 12.0, 12.0), // Adjust padding as needed
                                                  suffixIcon: !_isSearchExpanded? IconButton(
                                                      icon: const Icon(Icons.clear),
                                                      onPressed: () {
                                                        // Clear th`e search text
                                                        _searchFocusNode.unfocus( );
                                                      }

                                                  ): null,
                                                ),
                                              ),

                                              Positioned(
                                                  top: controller.value * 8,
                                                  child:
                                                  !_isSearchExpanded?
                                                  TextButton(onPressed: _openDrawer, child: const Icon(Icons.menu)): TextButton(
                                                      onPressed: _unfocusInput, child: const Icon(Icons.arrow_back))
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      );
                    },
                  )
              ),
              body: Center(
                child: Stack(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.bounceInOut,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child:
                          !_isSearchExpanded? screens[_selectedIndex]: null,
                      ),
                      if (_isSearchExpanded)
                        RepaintBoundary(
                            child: AnimatedOpacity(duration: const Duration(milliseconds: 300),
                              opacity: _resultFadeIn? 1: 0,

                              child: ListView.builder(
                                itemCount: 10, // Example number of results
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text('Result $index'),
                                    // Add your result item widget here
                                  );
                                },
                              ),
                            )
                        )

                    ]
                ),

              ),
              drawer: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                ),
                child: Drawer(
                  // Add a ListView to the drawer. This ensures the user can scroll
                  // through the options in the drawer if there isn't enough vertical
                  // space to fit everything.
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(64, 64, 64, 32),
                          child: Image.asset("assets/images/cloudy_sun.png", fit: BoxFit.fitHeight)
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 40),
                        minLeadingWidth: 10,
                        leading: const Icon(Icons.accessible),
                        title: const Text("Overlay"),
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                            overlayOriginatingCorner = Corner.bottomRight;
                            screenTransition.forward();

                            _showOverlayScreen = !_showOverlayScreen;
                          });
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 40),
                        minLeadingWidth: 10,
                        leading: const Icon(Icons.home),
                        title: const Text('First'),
                        selected: _selectedIndex == 0,
                        onTap: () {
                          // Update the state of the app
                          _onItemTapped(0);
                          // Then close the drawer
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 40),
                        minLeadingWidth: 10,
                        leading: const Icon(Icons.account_circle),
                        title: const Text('Second'),
                        selected: _selectedIndex == 1,
                        onTap: () {
                          // Update the state of the app
                          _onItemTapped(1);
                          // Then close the drawer
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              )
          ),
          if (_showOverlayScreen)
            AnimatedBuilder(
              animation: screenTransition,
              builder: (context, child) {
                final animationValue = screenTransitonAnimation.value;
                final safePadding = MediaQuery.of(context).padding.top;
                return Positioned(
                    top: safePadding,
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                        onDoubleTap: () {
                          overlayOriginatingCorner = Corner.topLeft;
                          screenTransition.reverse();
                        },
                        child: ClipOval(
                          clipper: ArchClipper(animationValue, overlayOriginatingCorner),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white, // Background color of the overlay
                            child: const OverlayScreen(),
                          ),
                        )
                    )
                );
              },
            )
        ]
    );
  }
}

enum Corner {
  bottomLeft,
  bottomRight,
  topLeft,
  topRight
}

class ArchClipper extends CustomClipper<Rect> {
  double animationValue;
  Corner corner;
  ArchClipper(this.animationValue, this.corner);

  @override
  Rect getClip(Size size) {
    final radius = (size.width + size.height)  * animationValue;
    Offset center = const Offset(0, 0);
    switch(corner) {
      case Corner.bottomRight:
        center = Offset(size.width, size.height);
        break;
      case Corner.bottomLeft:
        center = Offset(0, size.height);
        break;
      case Corner.topRight:
        center = Offset(size.width, 0);
        break;
      default:
        break;
    }

    return Rect.fromCircle(
      center: center,
      radius: radius,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class CustomMeterGraph extends StatefulWidget {
  final double value;

  const CustomMeterGraph({super.key, required this.value});

  @override
  State<CustomMeterGraph>  createState() => CustomMeterGraphState();
}

class CustomMeterGraphState  extends State<CustomMeterGraph> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  late          double value;

  void resetAnimation() {
    setState(() {
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = widget.value;

    _controller = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 500)
    );

    _animation = Tween<double>(
      begin: 0,
      end: value,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: 120, // slightly wider for the width of the stroke
                  height: 120,
                  child: ClipRect(
                    clipper: UpperHalfClipper(),
                    child: CustomPaint(
                      painter: MeterPainter(_animation.value, Colors.green),
                    ),
                  )
                ),
              );
            }
        ),
        const SizedBox(width: 40),
        AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: 120, // slightly wider for the width of the stroke
                  height: 120,
                  child: ClipRect(
                    clipper: UpperHalfClipper(),
                    child: CustomPaint(
                      painter: MeterPainter(_animation.value, Colors.blue),
                    ),
                  )
                ),
              );
            }
        )
      ],
    );
  }
}

class UpperHalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width, size.height / 1.5);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class MeterPainter extends CustomPainter {
  double value;
  Color color;

  MeterPainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width/2;
    double centerY = size.height/2;

    double strokeWidth = 12.0;
    double radius = min(centerX, centerY) - strokeWidth;
    double startAngle = -pi * 1.2;
    double sweepAngle = pi * value * 2.4;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
      canvas.drawArc(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}