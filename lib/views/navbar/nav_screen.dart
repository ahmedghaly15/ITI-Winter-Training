import 'package:flutter/material.dart';
import 'package:my_new_app/views/navbar/settings.dart';

import 'home.dart';
import 'profile.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Map<String, Widget>> pages = [
    {
      'page': const HomePage(),
      'title': const Text("Home Page"),
    },
    {
      'page': const SettingPage(),
      'title': const Text("Settings Page"),
    },
    {
      'page': const ProfileScreen(),
      'title': const Text("Profile Page"),
    },
  ];
  int _selectedPageIndex = 0;

  void _tap(int indx) {
    setState(() {
      _selectedPageIndex = indx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: pages[_selectedPageIndex]['title'],
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: _tap,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple[200],
        type: BottomNavigationBarType.shifting,
        selectedFontSize: 13,
        unselectedFontSize: 10,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
