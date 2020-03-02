import 'package:douban_game_flutter/view/home/library_view.dart';
import 'package:douban_game_flutter/view/home/search_view.dart';
import 'package:flutter/material.dart';

import 'home/home_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomeView(),
          SearchView(),
          LibraryView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text('My Library'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
