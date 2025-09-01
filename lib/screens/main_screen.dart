import 'package:flutter/material.dart';
import 'package:maverick/features/dashboard/home.dart';
import 'package:maverick/features/dashboard/wallet_screen.dart';
import 'package:maverick/screens/create_group.dart';
import 'package:maverick/screens/groups.dart';
import 'package:maverick/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;

  final List<Widget> _pages = [
    Home(),
    CreateGroup(),
    WalletScreen(),
    Groups(),
    SettingsScreen(),
  ];

  void _tabs(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTabIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.deepOrangeAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedTabIndex,
          onTap: _tabs,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add, size: 30), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined, size: 30),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 30),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
