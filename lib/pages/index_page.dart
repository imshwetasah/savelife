import 'package:flutter/material.dart';
import 'package:savelife/pages/contact_page.dart';
import 'package:savelife/pages/home_page.dart';
import 'package:savelife/pages/profile_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
    const ContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BottomNavigationBar(
            backgroundColor: Colors.red,
            elevation: 0.0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            selectedFontSize: 16.0,
            onTap: _navigateBottomBar,
            currentIndex: _selectedIndex,
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.help),
                label: 'Contact Us',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
