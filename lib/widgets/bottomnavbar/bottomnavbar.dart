import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:witwire/screens/create/create_screen.dart';
import 'package:witwire/screens/home/home_screen.dart';
import 'package:witwire/screens/myprofile/myprofile_screen.dart';
import 'package:witwire/screens/search/search_screen.dart';
import 'package:witwire/screens/top/topposts_screen.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/bottomnavbar/bottomnavbaritems.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  late int _currIndex;
  late BuildContext context;

  BottomNavBar(this._currIndex, {super.key});

  void onTap(int index) {
    if (index == _currIndex) return;
    Widget newPage;
    switch (index) {
      case 0:
        newPage = const HomeScreen();
        break;
      case 1:
        newPage = const SearchScreen();
        break;
      case 2:
        newPage = CreateScreen(userNeedsToUpload: false);
        break;
      case 3:
        newPage = const TopPostsScreen();
        break;
      case 4:
        newPage = const MyProfileScreen();
        break;
      default:
        throw Exception("Falscher Index.");
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => newPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return CupertinoTabBar(
      backgroundColor: navbarBackground,
      activeColor: navbaractive,
      inactiveColor: navbarinactive,
      currentIndex: _currIndex,
      onTap: onTap,
      items: BottomNavBarItems.getNavBarItems(),
    );
  }
}
