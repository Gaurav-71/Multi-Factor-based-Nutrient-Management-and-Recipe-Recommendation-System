import 'package:flutter/material.dart';
import 'package:recipedia/screens/navigation/home.dart';
import 'package:recipedia/screens/navigation/nutrition.dart';
import 'package:recipedia/screens/navigation/profile.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  final _screens = [const HomeTab(), const NutritionTab(), const ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: _screens
              .asMap()
              .map((i, screen) => MapEntry(
                  i,
                  Offstage(
                    offstage: _selectedIndex != i,
                    child: screen,
                  )))
              .values
              .toList()),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 1.0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() {
                _selectedIndex = i;
              }),
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.query_stats_outlined),
                activeIcon: Icon(Icons.query_stats),
                label: 'Nutrition Data'),
            BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts_outlined),
                activeIcon: Icon(Icons.manage_accounts),
                label: 'Profile'),
          ]),
    );
  }
}
