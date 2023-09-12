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
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.green,
        body: Text("First Screen")
    );
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
  bool _showOverlayScreen = false;
  late OverlayEntry detectorOverlay;
  late AnimationController controller;
  late AnimationController screenTransition;
  late Animation<double> enlargeAnimation;
  late Animation<double> screenTransitonAnimation;

  static List<Widget> screens = <Widget>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    enlargeAnimation = Tween<double>(begin: 0, end: 100).animate(controller);
    screenTransition = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    screenTransitonAnimation = Tween<double>(begin: 0, end: 1).animate(screenTransition);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (_isSearchExpanded) {
        _searchFocusNode.requestFocus();
      } else {
        _searchFocusNode.unfocus();
      }
    });
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
    screens.add(const FirstScreen());
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
                                  } else {
                                    setState(() {
                                      _isSearchExpanded = false;
                                      controller.reverse();
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
                      child: !_isSearchExpanded? screens[_selectedIndex]: null,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        // Implement your custom transition effect here
                        const begin = Offset(1.0, 1.0); // Bottom-right corner
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                    RepaintBoundary(
                        child: AnimatedOpacity(duration: const Duration(milliseconds: 300),
                          opacity: _isSearchExpanded? 1: 0,
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
                          _showOverlayScreen = !_showOverlayScreen;
                          if (_showOverlayScreen) {
                            screenTransition.forward();
                          } else {
                            screenTransition.reverse();
                          }
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
                  onDoubleTap: () => {
                    setState(() {
                      _showOverlayScreen = !_showOverlayScreen;
                      screenTransition.reverse();
                    })
                  },
                  child: ClipOval(
                    clipper: ArchClipper(animationValue),
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

class ArchClipper extends CustomClipper<Rect> {
  double animationValue;
  ArchClipper(this.animationValue);

  @override
  Rect getClip(Size size) {
    final radius = (size.width + size.height)  * animationValue;
    return Rect.fromCircle(
      center: Offset(size.width, size.height),
      radius: radius,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
