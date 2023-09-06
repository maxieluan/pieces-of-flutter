import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My App",
        home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Text("First Screen")
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
        body: Text("Second Screen")
    );
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchExpanded = false;
  late OverlayEntry detectorOverlay;
  late AnimationController controller;
  late Animation<double> enlargeAnimation;

  static List<Widget> screens = <Widget>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    enlargeAnimation = Tween<double>(begin: 0, end: 100).animate(controller);
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
    print("tapped");
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
    screens.add(SecondScreen());

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child){
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0 - 16*controller.value),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
              ),
              child: SafeArea(
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
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
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
                                        contentPadding: const EdgeInsets.fromLTRB(64.0, 12.0, 12.0, 12.0), // Adjust padding as needed
                                        suffixIcon: !_isSearchExpanded? IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              // Clear the search text
                                              _searchFocusNode.unfocus( );
                                            }

                                        ): null,
                                      ),
                                    ),
                                    if (!_isSearchExpanded)
                                      TextButton(onPressed: _openDrawer, child: Icon(Icons.menu))
                                    else
                                      TextButton(onPressed: _unfocusInput, child: Icon(Icons.arrow_back))
                                  ],
                                )
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
            );
          },
        )
      ),
      body: Center(
        child: Stack(
            children: [
              if(!_isSearchExpanded) screens[_selectedIndex],
              AnimatedOpacity(duration: Duration(milliseconds: 300),
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
            ]
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
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
    );
  }
}