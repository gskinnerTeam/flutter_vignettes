import 'dart:math';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'content/gallery_page.dart';
import 'content/home_page.dart';
import 'content/camera_page.dart';
import 'content/likes_page.dart';
import 'content/save_page.dart';
import 'navbar.dart';

class BubbleTabBarDemo extends StatefulWidget {
  @override
  _BubbleTabBarDemoState createState() => _BubbleTabBarDemoState();
}

class _BubbleTabBarDemoState extends State<BubbleTabBarDemo> {
  List<NavBarItemData> _navBarItems;
  int _selectedNavIndex = 0;

  List<Widget> _viewsByIndex;

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", OMIcons.home, 120, Color(0xff01b87d), Color(0xffebf8f3)),
      NavBarItemData("Gallery", OMIcons.image, 120, Color(0xff594ccf), Color(0xfff0f0fc)),
      NavBarItemData("Camera", OMIcons.camera, 120, Color(0xff09a8d9), Color(0xffe7f6fb)),
      NavBarItemData("Likes", OMIcons.favoriteBorder, 120, Color(0xffcf4c7a), Color(0xfffaf0f3)),
      NavBarItemData("Saved", OMIcons.save, 120, Color(0xfff2873f), Color(0xfffbe9d6)),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomePage(),
      GalleryPage(),
      CameraPage(),
      LikesPage(),
      SavePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );
    //Display the correct child view for the current index
    var contentView = _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      backgroundColor: Color(0xffE6E6E6),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            child: contentView,
          ),
        ),
      ),
      bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
    );
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}
