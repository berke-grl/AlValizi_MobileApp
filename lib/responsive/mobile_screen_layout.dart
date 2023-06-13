import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/utils/varriables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _pageNumber = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void changeScreen(int pageNum) {
    pageController.jumpToPage(pageNum);
  }

  void onPageChanged(int page) {
    setState(() {
      _pageNumber = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            color: _pageNumber == 0 ? Colors.green : Colors.grey,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.search,
            color: _pageNumber == 1 ? Colors.green : Colors.grey,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.add_circle,
            color: _pageNumber == 2 ? Colors.green : Colors.grey,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.map,
            color: _pageNumber == 3 ? Colors.green : Colors.grey,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.person,
            color: _pageNumber == 4 ? Colors.green : Colors.grey,
          )),
        ],
        onTap: changeScreen,
      ),
    );
  }
}
