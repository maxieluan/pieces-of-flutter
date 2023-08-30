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
    return Scaffold(
        body: Text("First Screen")
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Text("Second Screen")
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearchExpanded = false;

  static List<Widget> screens = <Widget>[];

  @override
  void initState() {
    super.initState();
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



  @override
  Widget build(BuildContext context) {
    screens.add(FirstScreen());
    screens.add(SecondScreen());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleSearch,
                child: Icon(Icons.search)
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _isSearchExpanded ? MediaQuery.of(context).size.width - 72 : 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: screens[_selectedIndex],
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