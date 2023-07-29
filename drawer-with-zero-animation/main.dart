import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "demo",
      routes: {
        "/": (context) => const HomeScreen(),
        "/Second": (context) => const SecondScreen(),
      },
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: const SizedBox(
        height: 20,
        child: Text("Second",
            style: TextStyle(
                color: Colors.deepOrange, fontFamily: "Times New Roman")),
      )),
      drawer: AppDrawer(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const SizedBox(
          height: 20,
          child: Text("Text",
              style: TextStyle(
                  color: Colors.deepOrange, fontFamily: "Times New Roman")),
        )),
        drawer: AppDrawer());
  }
}

class MenuItem {
  final String title;
  final String route;
  final Widget screen;

  MenuItem(this.title, this.route, this.screen);
}

class AppDrawer extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem("Home", "/", HomeScreen()),
    MenuItem("Second", "/Second", SecondScreen())
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView.builder(
            itemCount: menuItems.length + 1,
            itemBuilder: (context, index) {
              if (index <= 0) {
                return Container(
                  height: 55,
                  alignment: Alignment.bottomLeft,
                  child: const DrawerHeader(
                    child: Text("Drawer Header"),
                  ),
                );
              } else {
                final menuItem = menuItems[index - 1];
                var isSameRoute =
                    ModalRoute.of(context)?.settings.name == menuItem.route;
                return ListTile(
                  title: Text(menuItem.title),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => menuItem.screen,
                            transitionDuration: const Duration(seconds: 0)));
                  },
                );
              }
            })
    );
  }
}
