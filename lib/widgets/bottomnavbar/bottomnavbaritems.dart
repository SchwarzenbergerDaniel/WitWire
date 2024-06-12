import 'package:flutter/material.dart';

class BottomNavBarItems {
  static List<BottomNavigationBarItem> getNavBarItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: "Suche"),
      BottomNavigationBarItem(icon: Icon(Icons.date_range), label: "Gestern"),
      BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: "Entdecke"),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), label: "Profil"),
    ];
  }
}
