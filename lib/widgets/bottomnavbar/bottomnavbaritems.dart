import 'package:flutter/material.dart';

class BottomNavBarItems {
  static List<BottomNavigationBarItem> getNavBarItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.whatshot),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
      ),
    ];
  }
}
